//
//  NetworkService.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/14/24.
//

import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(url: URL,
        method: HTTPMethod,
        parameters: [String: Any]?) async throws -> T
    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        parameters: [String: Any]?) async throws -> T
}

class NetworkClient: NetworkClientProtocol {
    private let scheme: String = "https"
    private let host: String = "themealdb.com"
    private let prefix: String = "/api/json/v1/1"

    private let session: URLSessionProtocol
    private let decoder: JSONDecoder = JSONDecoder()

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func request<T: Decodable>(
        url: URL,
        method: HTTPMethod,
        parameters: [String: Any]?
    ) async throws -> T {
        let request = try buildURLRequest(url: url, method: method, parameters: parameters)
        return try await executeRequest(request, method: method, parameters: parameters)
    }

    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        parameters: [String: Any]?
    ) async throws -> T {
        let request = try buildURLRequest(path: path, method: method, parameters: parameters)
        return try await executeRequest(request, method: method, parameters: parameters)
    }

    // Execute the request and decode the response
    private func executeRequest<T: Decodable>(
        _ request: URLRequest,
        method: HTTPMethod,
        parameters: [String: Any]?
    ) async throws -> T {
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        guard !data.isEmpty else {
            throw URLError(.cannotParseResponse)
        }

        return try decoder.decode(T.self, from: data)
    }

}

extension NetworkClient {
    // Build the URL request with parameters
    private func buildURLRequest(
        url: URL,
        method: HTTPMethod,
        parameters: [String: Any]?
    ) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let parameters = parameters {
            switch method {
            case .post, .put, .delete:
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            case .get:
                break
            }
        }

        return request
    }

    // Build a URL request from path and parameters, constructing the full URL
    private func buildURLRequest(
        path: String,
        method: HTTPMethod,
        parameters: [String: Any]?
    ) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = prefix + path

        if method == .get, let parameters = parameters {
            let queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw URLError(.badURL)
        }
        print("Constructed URL: \(url)")

        return try buildURLRequest(url: url, method: method, parameters: parameters)
    }
}

// Allows testing
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
