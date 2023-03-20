//
//  InputError.swift
//  NBP
//
//  Created by Maksymilian Stan on 19/03/2023.
//

import Foundation

enum InputError: String, Error {
    case defaultError = "Something went wrong."
    case badQuantityError = "Bad quantity. Please enter again."
    case noCurrency = "Please choose currency."
}
