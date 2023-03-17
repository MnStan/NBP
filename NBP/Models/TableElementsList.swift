//
//  TableElementsList.swift
//  NBP
//
//  Created by Maksymilian Stan on 17/03/2023.
//

import Foundation

protocol TableElementsListProtocol {
    var publicationDate: String { get set }
    var tableNumber: String { get set }
    var tableElements: [TableElementProtocol] { get set }
    
    func setPublicationDate(date: String)
    func getPublicationDate() -> String
    func setTableNumber(tableNumber: String)
    func getTableNumber() -> String
    func addTableElement(tableElement: TableElementProtocol)
}

extension TableElementsListProtocol {
    func setPublicationDate(date: String) {  }
    func getPublicationDate() -> String { return "" }
    func setTableNumber(tableNumber: String) {  }
    func getTableNumber() -> String { return "" }
    func addTableElement(tableElement: TableElementProtocol) {  }
}

class TableElementsList: TableElementsListProtocol {
    var publicationDate: String
    var tableNumber: String
    var tableElements: [TableElementProtocol]
    
    init(publicationDate: String = "", tableNumber: String = "", tableElements: [TableElementProtocol] = []) {
        self.publicationDate = publicationDate
        self.tableElements = tableElements
        self.tableNumber = tableNumber
    }
    
    func setPublicationDate(date: String) {
        publicationDate = date
    }
    
    func getPublicationDate() -> String {
        return publicationDate
    }
    
    func setTableNumber(tableNumber: String) {
        self.tableNumber = tableNumber
    }
    
    func getTableNumber() -> String {
        return tableNumber
    }
    
    func addTableElement(tableElement: TableElementProtocol) {
        tableElements.append(tableElement)
    }
    

}
