//
//  ParseXMLTests.swift
//  NBPTests
//
//  Created by Maksymilian Stan on 16/03/2023.
//

import XCTest
@testable import NBP

class TableElementStub: TableElementProtocol {    
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
}

class TableElementsListStub: TableElementsListProtocol {
    var publicationDate: String = "2023-03-17"
    
    var tableNumber: String = "054/A/NBP/2023"
    
    var tableElements: [NBP.TableElementProtocol] = [TableElementStub(currencyName: "bat (Tajlandia)", currencyRate: "1", currencyCode: "THB", currencyAverageRate: "0.1291"), TableElementStub(currencyName: "dolar amerykański", currencyRate: "1", currencyCode: "USD", currencyAverageRate: "4.4202")]
    
    func isEqual(to: TableElementsListProtocol) -> Bool {
        var isEqual = false
        if publicationDate == to.getPublicationDate() {
            if tableNumber == to.getTableNumber() {
                tableElements.enumerated().forEach {
                    print($0, to.tableElements[$0.offset])
                    if $0.element.currencyName == to.tableElements[$0.offset].getCurrencyName() {
                        if $0.element.currencyCode == to.tableElements[$0.offset].getCurrencyCode() {
                            if $0.element.currencyRate == to.tableElements[$0.offset].getCurrencyRate() {
                                if $0.element.currencyAverageRate == to.tableElements[$0.offset].getCurrencyAverageRate() {
                                    isEqual = true
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return isEqual
    }
}

final class ParseXMLTests: XCTestCase {
    var data: Data!
    
    override func setUpWithError() throws {
        guard let url = Bundle(for: Self.self).url(forResource: "xmlStubData", withExtension: "xml") else {
            XCTFail("Can't find .xml file")
            return
        }
        
        data = try? Data(contentsOf: url)
        guard data != nil else {
            XCTFail("Can't get data from .xml file")
            return
        }
    }
    
    func testParseReturn() {
        // given
        let sut = Parser()
        let stub = TableElementsListStub()
        
        // when
        var parseResult: TableElementsListProtocol?
        sut.parse(data: data) { result in
            parseResult = result
        }
        
        // then
        if let parseResult {
            XCTAssertTrue(stub.isEqual(to: parseResult))
        } else {
            XCTFail("Parse result nil")
        }
    }
}
