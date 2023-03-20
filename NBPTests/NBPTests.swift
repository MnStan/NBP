//
//  NBPTests.swift
//  NBPTests
//
//  Created by Maksymilian Stan on 15/03/2023.
//

import XCTest
@testable import NBP

class ViewModelMock: ExchangeViewModelProtocol {
    var model: TableElementsListProtocol = TableElementsListStub()
    var currency: Observable<String> = Observable("THB")
    var quantity: Observable<String> = Observable("100")
    var toGetCurrency: Observable<String> = Observable("USD")
    var output: Observable<String> = Observable("")
    var errorObservable: NBP.Observable<Error> = Observable(NetworkError.defaultError)
    
}

class ViewModelBadInputMock: ExchangeViewModelProtocol {
    var model: TableElementsListProtocol = TableElementsListStub()
    var currency: Observable<String> = Observable("THB")
    var quantity: Observable<String> = Observable("asd")
    var toGetCurrency: Observable<String> = Observable("USD")
    var output: Observable<String> = Observable("")
    var errorObservable: NBP.Observable<Error> = Observable(NetworkError.defaultError)
    
}

final class NBPTests: XCTestCase {
    
    func testViewModelgetDataSetObservableToErrorResponse() {
        // given
        let mock = MockNetworkSessionInvalidResponse()
        let sut = ExchangeViewModel()
        
        let expectation = XCTestExpectation(description: "Observable object should be NetworkError.invalidResponse")
        
        // when
        sut.errorObservable.valueChanged = { error in
            // then
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidResponse.self)
            expectation.fulfill()
        }
        
        sut.getData(session: mock)
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testViewModelgetDataSetObservableToErrorURL() {
        // given
        let mock = MockNetworkSessionInvalidURL()
        let sut = ExchangeViewModel()
        
        let expectation = XCTestExpectation(description: "Observable object should be NetworkError.invalidResponse")
        
        
        // when
        sut.errorObservable.valueChanged = { error in
            // then
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidURL.self)
            expectation.fulfill()
        }
        
        sut.getData(url: " ", session: mock)
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testFindAndCalculateShouldReturn292() {
        // given
        let sut = ViewModelMock()
        sut.model.tableElements[0].setCurrencyAverageRate(rate: "0.1291")
        sut.model.tableElements[1].setCurrencyAverageRate(rate: "4.4202")
        
        // when
        sut.findAndCalculate(model: sut.model)
        
        // then
        XCTAssertEqual(sut.output.value, "2.92")
    }
    
    func testChangeCommasToDots() {
        // given
        let sut = ViewModelMock()
        
        // when
        sut.changeCommasToDots()
        
        // then
        XCTAssertEqual(sut.model.tableElements[0].currencyAverageRate, "0.1291")
    }
    
    func testGetCurrencyNamesAndCodes() {
        // given
        let sut = ViewModelMock()
        
        // when
        let names = sut.getCurrencyNamesAndCodes(model: sut.model)
        
        // then
        XCTAssertEqual(names[0].value, "THB")
    }
    
    func testFindAndCalculateShouldGiveError() {
        // given
        let sut = ViewModelBadInputMock()
        sut.model.tableElements[0].setCurrencyAverageRate(rate: "0.1291")
        sut.model.tableElements[1].setCurrencyAverageRate(rate: "4.4202")
        
        // when
        sut.findAndCalculate(model: sut.model)
        
        // then
        XCTAssertEqual(sut.errorObservable.value as! InputError, InputError.badQuantityError)
    }
}
