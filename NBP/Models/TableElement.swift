//
//  TableElements.swift
//  NBP
//
//  Created by Maksymilian Stan on 17/03/2023.
//

import Foundation

protocol TableElementProtocol {
    var currencyName: String { get set }
    var currencyRate: String { get set }
    var currencyCode: String { get set }
    var currencyAverageRate: String { get set }
    
    func setCurrencyName(name: String)
    func getCurrencyName() -> String
    func setCurrencyRate(rate: String)
    func getCurrencyRate() -> String
    func setCurrencyCode(code: String)
    func getCurrencyCode() -> String
    func setCurrencyAverageRate(rate: String)
    func getCurrencyAverageRate() -> String
}

extension TableElementProtocol {
    func setCurrencyName(name: String) {  }
    func getCurrencyName() -> String { "" }
    func setCurrencyRate(rate: String) {  }
    func getCurrencyRate() -> String { "" }
    func setCurrencyCode(code: String) {  }
    func getCurrencyCode() -> String { "" }
    func setCurrencyAverageRate(rate: String) {  }
    func getCurrencyAverageRate() -> String { "" }
    
}

class TableElement: TableElementProtocol {
    var currencyName: String
    var currencyRate: String
    var currencyCode: String
    var currencyAverageRate: String
    
    init(currencyName: String, currencyRate: String, currencyCode: String, currencyAverageRate: String) {
        self.currencyName = currencyName
        self.currencyRate = currencyRate
        self.currencyCode = currencyCode
        self.currencyAverageRate = currencyAverageRate
    }
    
    func setCurrencyName(name: String) {
        currencyName = name
    }
    
    func getCurrencyName() -> String {
        return currencyName
    }
    
    func setCurrencyRate(rate: String) {
        currencyRate = rate
    }
    
    func getCurrencyRate() -> String {
        return currencyRate
    }
    
    func setCurrencyCode(code: String) {
        currencyCode = code
    }
    
    func getCurrencyCode() -> String {
        return currencyCode
    }
    
    func setCurrencyAverageRate(rate: String) {
        currencyAverageRate = rate
    }
    
    func getCurrencyAverageRate() -> String {
        return currencyAverageRate
    }
}
