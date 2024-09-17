//
//  NetworkProvider.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/16/24.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class NetworkProvider<NetworkEndpoint: Endpoint> {
    let client: NetworkClientProtocol

    init(client: NetworkClientProtocol = NetworkClient()) {
        self.client = client
    }

    func request<T: Decodable>(_ endpoint: NetworkEndpoint) async throws -> T {
        return try await self.client.request(
            path: endpoint.path,
            method: endpoint.method,
            parameters: endpoint.parameters
        )
    }
}
