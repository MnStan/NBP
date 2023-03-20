//
//  InputTextField.swift
//  NBP
//
//  Created by Maksymilian Stan on 19/03/2023.
//

import UIKit

class InputTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTextField() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        textAlignment = .center
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.lightGray.cgColor
        keyboardType = .decimalPad
    }
}
