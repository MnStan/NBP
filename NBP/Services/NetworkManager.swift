//
//  NetworkManager.swift
//  NBP
//
//  Created by Maksymilian Stan on 15/03/2023.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {  }

protocol NetworkSession {
    func getXML(for url: String, networkSession: URLSessionProtocol) async throws -> (Data, URLResponse)
}

class NetworkManager: NetworkSession {
    static let shared = NetworkManager()
    
    func getXML(for url: String = "https://www.nbp.pl/kursy/xml/lastaa.xml", networkSession: URLSessionProtocol = URLSession.shared) async throws -> (Data, URLResponse) {
        guard let urlFromString = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        let (data, response) = try await networkSession.data(from: urlFromString, delegate: nil)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        return (data, response)
    }
    
}
