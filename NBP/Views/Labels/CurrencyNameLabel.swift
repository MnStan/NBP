//
//  CurrencyNameLabel.swift
//  NBP
//
//  Created by Maksymilian Stan on 20/03/2023.
//

import UIKit

class CurrencyNameLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        font = UIFont.systemFont(ofSize: 14)
        textColor = .lightGray
        textAlignment = .center
    }
    
    func setBackground(color: UIColor?) {
        backgroundColor = color
    }
    
    func changeText(to: String) {
        isHidden = false
        text = to
    }
}
