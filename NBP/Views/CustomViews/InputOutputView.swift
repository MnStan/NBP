//
//  InputOutputView.swift
//  NBP
//
//  Created by Maksymilian Stan on 20/03/2023.
//

import UIKit

class InputOutputView: UIView {
    let inputTextField = InputTextField()
    let currencyNameLabel = CurrencyNameLabel()
    let button = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(backgroundColor: UIColor?) {
        self.init(frame: .zero)
        addElements()
        configureLayout()
        currencyNameLabel.setBackground(color: backgroundColor)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
    
    private func configureButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        button.backgroundColor = .systemBackground
        button.tintColor = .lightGray
        button.isHidden = true
        button.alpha = 0
    }
    
    private func addElements() {
        addSubview(inputTextField)
        addSubview(currencyNameLabel)
        addSubview(button)
    }
    
    private func configureNameLabel() {
        currencyNameLabel.isHidden = true
        currencyNameLabel.alpha = 0
    }
    
    private func configureLayout() {
        let textFieldPadding: CGFloat = 10
        NSLayoutConstraint.activate([
            inputTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: textFieldPadding),
            inputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: textFieldPadding),
            inputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -textFieldPadding),
            inputTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -textFieldPadding),
            
            currencyNameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            currencyNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3 * textFieldPadding),
            currencyNameLabel.heightAnchor.constraint(equalToConstant: 28),
            currencyNameLabel.widthAnchor.constraint(equalToConstant: 50),
            
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -3 * textFieldPadding),
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func hideNameLabel() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.5, delay: 0) {
                self.currencyNameLabel.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                self.currencyNameLabel.alpha = 0
                self.currencyNameLabel.transform = self.transform
            } completion: { _ in
                self.currencyNameLabel.isHidden = true
            }
        }
    }
    
    func hideNameLabelWithoutAnimation() {
        DispatchQueue.main.async {
            self.currencyNameLabel.isHidden = true
            self.currencyNameLabel.alpha = 0
        }
    }
    
    func showNameLabel() {
        DispatchQueue.main.async {
            self.currencyNameLabel.isHidden = false
            UIView.animate(withDuration: 1, delay: 0) {
                self.currencyNameLabel.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
                self.currencyNameLabel.transform = CGAffineTransform(translationX: 0, y: -10)
                self.currencyNameLabel.alpha = 1
                self.currencyNameLabel.transform = self.transform
            }
        }
    }
    
    func showButton() {
        DispatchQueue.main.async {
            self.button.isHidden = false
            UIView.animate(withDuration: 1, delay: 0) {
                self.button.transform = CGAffineTransform(scaleX: 3.3, y: 3.3)
                self.button.transform = CGAffineTransform(translationX: 0, y: 10)
                self.button.alpha = 1
                self.button.transform = self.transform
            }
        }
    }
}

