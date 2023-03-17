//
//  Parser.swift
//  NBP
//
//  Created by Maksymilian Stan on 17/03/2023.
//

import Foundation

protocol ParserProtocol: NSObject, XMLParserDelegate {
    func parse(data: Data, completionHandler: ((TableElementsList) -> ())?)
}


class Parser: NSObject, ParserProtocol {
    var startOfFile: Bool?
    var endOfFile: Bool?
    var parseError: Bool?
    
    private var elementsList = TableElementsList()

    private var currentElement: String = ""
    private var currentName: String = "" {
        didSet {
            currentName = currentName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentRate: String = "" {
        didSet {
            currentRate = currentRate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentCode: String = "" {
        didSet {
            currentCode = currentCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentAverageRate: String = "" {
        didSet {
            currentAverageRate = currentAverageRate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var tableNumber: String = "" {
        didSet {
            tableNumber = tableNumber.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var publicationDate: String = "" {
        didSet {
            publicationDate = publicationDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler: ((TableElementsList) -> ())?
    
    func parse(data: Data, completionHandler: ((TableElementsList) -> ())? = nil) {
        self.parserCompletionHandler = completionHandler
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        startOfFile = true
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        endOfFile = true
        parserCompletionHandler?(elementsList)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if currentElement == "pozycja" {
            currentName = ""
            currentRate = ""
            currentCode = ""
            currentAverageRate = ""
        }
        
        if currentElement == "numer_tabeli" {
            tableNumber = ""
        }
        
        if currentElement == "data_publikacji" {
            publicationDate = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "nazwa_waluty":
            currentName += string
            
        case "przelicznik":
            currentRate += string
            
        case "kod_waluty":
            currentCode += string
            
        case "kurs_sredni":
            currentAverageRate += string
            
        case "numer_tabeli":
            tableNumber += string
            
        case "data_publikacji":
            publicationDate += string
        
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "pozycja":
            elementsList.tableElements.append(TableElement(currencyName: currentName, currencyRate: currentRate, currencyCode: currentCode, currencyAverageRate: currentAverageRate))
            
        case "numer_tabeli":
            elementsList.setTableNumber(tableNumber: tableNumber)
            
        case "data_publikacji":
            elementsList.publicationDate = publicationDate
            
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.parseError = true
    }
}
