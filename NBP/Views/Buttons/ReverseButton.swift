//
//  ReverseButton.swift
//  NBP
//
//  Created by Maksymilian Stan on 20/03/2023.
//

import UIKit

class ReverseButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        configuration = UIButton.Configuration.plain()
        configuration?.baseForegroundColor = .lightGray
        configuration?.image = UIImage(systemName: "arrow.up.arrow.down")
        layer.borderWidth = 2
        layer.cornerRadius = 5
        layer.borderColor = UIColor.lightGray.cgColor
        
    }
}
