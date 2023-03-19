//
//  Observable.swift
//  NBP
//
//  Created by Maksymilian Stan on 19/03/2023.
//

import Foundation

class Observable<ObservedType> {
    private var _value: ObservedType
    
    var valueChanged: ((ObservedType?) -> ())?
    
    public var value: ObservedType {
        get {
            return _value
        }
        
        set {
            _value = newValue
            valueChanged?(_value)
        }
    }
    
    init(_ value: ObservedType) {
        _value = value
    }
    
    func bindingChanged(to newValue: ObservedType) {
        _value = newValue
    }
    
    func bind(valueChanged: ((ObservedType) -> Void)?) {
        valueChanged?(value)
    }
    
    func updateValue(value: ObservedType, completion: (_ value: ObservedType) -> Void) {
        self.value = value
        completion(value)
    }
}
