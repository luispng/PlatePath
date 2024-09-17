//
//  NetworkProviderTests.swift
//  PlatePathTests
//
//  Created by Luis Paniagua on 9/16/24.
//

import XCTest
@testable import PlatePath

class NetworkProviderTests: XCTestCase {

    struct GenericEndpoint: Endpoint {
        let path: String
        let method: HTTPMethod
        let parameters: [String: Any]?
    }

    class MockURLSession: URLSessionProtocol {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        func data(for request: URLRequest) async throws -> (Data, URLResponse) {
            if let error = error {
                throw error
            }
            return (data ?? Data(), response ?? URLResponse())
        }
    }

    // Success Test for NetworkProvider
    func testNetworkProviderRequestSuccess() async throws {
        let mockSession = MockURLSession()
        let networkClient = NetworkClient(session: mockSession)
        let provider = NetworkProvider<GenericEndpoint>(client: networkClient)

        // Expected response
        let expectedData = """
        {
            "meals": [{"idMeal": "52772", "strMeal": "Apple Frangipan Tart", "strMealThumb": "image-url"}]
        }
        """.data(using: .utf8)!

        // Expected successful network call
        mockSession.data = expectedData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://themealdb.com/api/json/v1/1/filter.php")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        // Define a mock endpoint
        let endpoint = GenericEndpoint(path: "/filter.php", method: .get, parameters: nil)

        // Request
        let response: MealListResponse = try await provider.request(endpoint)

        // Response should be correctly parsed
        XCTAssertEqual(response.meals.count, 1)
        XCTAssertEqual(response.meals.first?.id, "52772")
        XCTAssertEqual(response.meals.first?.name, "Apple Frangipan Tart")
    }

    // Failed Network Request Test
    func testNetworkProviderRequestFailure() async throws {
        let mockSession = MockURLSession()
        let networkClient = NetworkClient(session: mockSession)
        let provider = NetworkProvider<GenericEndpoint>(client: networkClient)

        // Set expected network error
        mockSession.error = URLError(.notConnectedToInternet)

        // Define mock endpoint
        let endpoint = GenericEndpoint(path: "/filter.php", method: .get, parameters: nil)

        // Request and expecting failure
        do {
            _ = try await provider.request(endpoint) as MealListResponse
            XCTFail("Expected error but got success")
        } catch let error as URLError {
            // Then: Correct error should be thrown
            XCTAssertEqual(error.code, .notConnectedToInternet)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // Testing POST Request with Parameters
    func testNetworkProviderPOSTRequest() async throws {
        let mockSession = MockURLSession()
        let networkClient = NetworkClient(session: mockSession)
        let provider = NetworkProvider<GenericEndpoint>(client: networkClient)

        // Expected response for POST request
        let expectedData = """
        {
            "success": true
        }
        """.data(using: .utf8)!
        mockSession.data = expectedData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com/api/submit")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        // mock POST endpoint
        let parameters = ["key": "value"]
        let endpoint = GenericEndpoint(path: "/submit", method: .post, parameters: parameters)

        // POST request
        let response: [String: Bool] = try await provider.request(endpoint)

        // response is successfully parsed
        XCTAssertEqual(response["success"], true)
    }
}
