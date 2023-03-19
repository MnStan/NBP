//
//  ExchangeViewModel.swift
//  NBP
//
//  Created by Maksymilian Stan on 19/03/2023.
//

import Foundation

protocol ExchangeViewModelProtocol {
    var model: TableElementsListProtocol { get set }
    var currency: Observable<String> { get set }
    var quantity: Observable<String> { get set }
    var toGetCurrency: Observable<String> { get set }
    var output: Observable<String> { get set }
    var errorObservable: Observable<Error> { get set }
    
    func findAndCalculate(model: TableElementsListProtocol)
    func getCurrencyNames(model: TableElementsListProtocol) -> [String]
    func getCurrencyCodes(model: TableElementsListProtocol) -> [String]
    mutating func changeCommasToDots()
}

extension ExchangeViewModelProtocol {
    func changeCommasToDots() {
        model.tableElements.forEach {
            $0.setCurrencyAverageRate(rate: $0.currencyAverageRate.replacingOccurrences(of: ",", with: "."))
        }
    }
    
    func findAndCalculate(model: TableElementsListProtocol) {
        let source = model.tableElements.first { element in
            element.currencyCode == currency.value
        }
        
        let destination = model.tableElements.first { element in
            element.currencyCode == toGetCurrency.value
        }
        
        if let source = source, let destination = destination {
            guard let sourceRate = Double(source.currencyRate) else {
                errorObservable.value = NetworkError.defaultError
                return
            }
            guard let sourceAvgRate = Double(source.currencyAverageRate) else {
                errorObservable.value = InputError.defaultError
                return
            }
            guard let destinationRate = Double(destination.currencyRate) else {
                errorObservable.value = InputError.defaultError
                return
            }
            guard let destinationAvgRate = Double(destination.currencyAverageRate) else {
                errorObservable.value = InputError.defaultError
                return
            }
            guard let doubleQuantity = Double(quantity.value) else {
                errorObservable.value = InputError.badQuantityError
                return
            }
            
            output.value = String(format: "%.2f", doubleQuantity * ((sourceAvgRate / sourceRate) / (destinationAvgRate / destinationRate)))
        } else {
            errorObservable.value = InputError.defaultError
        }
    }
    

    
    func getCurrencyNames(model: TableElementsListProtocol) -> [String] {
        var currencyNamesArray: [String] = []
        currencyNamesArray.reserveCapacity(model.tableElements.count)
        
        model.tableElements.forEach {
            currencyNamesArray.append($0.currencyName)
        }
        
        return currencyNamesArray
    }
    
    func getCurrencyCodes(model: TableElementsListProtocol) -> [String] {
        var currencyNamesArray: [String] = []
        currencyNamesArray.reserveCapacity(model.tableElements.count)
        
        model.tableElements.forEach {
            currencyNamesArray.append($0.currencyCode)
        }
        
        return currencyNamesArray
    }
}

class ExchangeViewModel: ExchangeViewModelProtocol {
    private let networkManager = NetworkManager.shared
    private let parser = Parser()
    
    var model: TableElementsListProtocol
    var currency: Observable<String> = Observable("")
    var quantity: Observable<String> = Observable("")
    var toGetCurrency: Observable<String> = Observable("")
    var output: Observable<String> = Observable("")
    var errorObservable: Observable<Error> = Observable(NetworkError.defaultError)
    
    init(model: TableElementsListProtocol = TableElementsList()) {
        self.model = model
    }
    
    func getData(url: String = "https://www.nbp.pl/kursy/xml/lasta.xml", session: URLSessionProtocol = URLSession.shared) {
        Task {
            do {
                let data = try await networkManager.getXML(for: url, networkSession: session).0
                
                parser.parse(data: data) { [weak self] parsedModel in
                    guard let self else { return }
                    self.model = parsedModel
                    self.changeCommasToDots()
                }
                
            } catch {
                print("Catch block")
                switch error {
                case NetworkError.invalidURL:
                    errorObservable.value = error
                case NetworkError.invalidResponse:
                    errorObservable.value = error
                default:
                    print("tutaj")
                    errorObservable.value = NetworkError.defaultError
                }
            }
        }
    }
    
    func changeCommasToDots() {
        model.tableElements.forEach {
            $0.setCurrencyAverageRate(rate: $0.currencyAverageRate.replacingOccurrences(of: ",", with: "."))
        }
    }
    
    func calculate() {
        findAndCalculate(model: model)
    }
    
    func getNames() -> [String] {
        getCurrencyNames(model: model)
    }
    
    func getCodes() -> [String] {
        getCurrencyCodes(model: model)
    }
    
}
