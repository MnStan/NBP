//
//  NetworkTests.swift
//  NBPTests
//
//  Created by Maksymilian Stan on 15/03/2023.
//

import XCTest
@testable import NBP



class MockNetworkSession: URLSessionProtocol {
    var lastURL: URL?
    
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        let data = "Hello".data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "www.test.com")!, statusCode: 200, httpVersion: nil, headerFields: [:])!
        lastURL = url
        
        return (data, response)
    }
}

class MockNetworkSessionInvalidResponse: URLSessionProtocol {
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        let data = "Hello".data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "www.test.com")!, statusCode: 300, httpVersion: nil, headerFields: [:])!
        
        return (data, response)
    }
}

final class NetworkTests: XCTestCase {
    func testNetworkManagerReturnHello() async {
        // given
        let sessionMock = MockNetworkSession()
        let sut = NetworkManager.shared
        var data: Data!
        
        // when
        do {
            data = try await sut.getXML(for: "test.test", networkSession: sessionMock).0
        } catch {
            XCTFail("Error when fetching data")
        }
        
        // then
        XCTAssertEqual(String(data: data, encoding: .utf8), "Hello")
    }
    
    func testNetworkManagerRequestCorrectURL() async {
        // given
        let sessionMock = MockNetworkSession()
        let sut = NetworkManager.shared
        
        // when
        do {
            _ = try await sut.getXML(for: "test.test", networkSession: sessionMock)
        } catch {
            XCTFail("Error when fetching data")
        }
        
        // then
        XCTAssertEqual(sessionMock.lastURL, URL(string: "test.test"))
    }
    
    func testNetworkManagerRequestIncorrectURL() async {
        // given
        let sessionMock = MockNetworkSession()
        let sut = NetworkManager.shared
        let expectation = expectation(description: "Call to getXML should throw invalid URL error")
        
        // when
        do {
            _ = try await sut.getXML(for: "test test", networkSession: sessionMock)
        } catch {
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 1)
    }
    
    func testNetworkManagerReturnCorrectResponse() async {
        // given
        let sessionMock = MockNetworkSession()
        let sut = NetworkManager()
        var response: HTTPURLResponse!
        
        // when
        do {
            response = try await sut.getXML(for: "1", networkSession: sessionMock).1 as? HTTPURLResponse
        } catch {
            XCTFail("Error when fetching data")
        }
        
        // then
        XCTAssertEqual(response.statusCode, 200)
    }
    
    func testNetworkManagerReturnIncorrectResponse() async {
        // given
        let sessionMock = MockNetworkSessionInvalidResponse()
        let sut = NetworkManager()
        let expectation = expectation(description: "Call to getXML should throw invalid response error")
        
        // when
        do {
            _ = try await sut.getXML(for: "1", networkSession: sessionMock).1 as? HTTPURLResponse
        } catch {
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 1)
    }
}

