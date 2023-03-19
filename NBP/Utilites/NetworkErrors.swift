//
//  NetworkErrors.swift
//  NBP
//
//  Created by Maksymilian Stan on 16/03/2023.
//

import Foundation

enum NetworkError: String, Error {
    case invalidURL = "Something went wrong with provided URL."
    case invalidResponse = "Something went wrong with response from server."
    case defaultError = "Something went wrong."
}
