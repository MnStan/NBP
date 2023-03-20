//
//  ViewController.swift
//  NBP
//
//  Created by Maksymilian Stan on 15/03/2023.
//

import UIKit

class ViewController: UIViewController {
    var viewModel = ExchangeViewModel()
    var currencyInputView: InputOutputView!
    var currencyOutputView: InputOutputView!
    var reverseButton = ReverseButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        addObserversForKeyboard()
        createDismissKeyboardTapGesture()
        
        addReverseButton()
        addInputAndOutputViews()
        
        addBindings()
        
        viewModel.getData { [weak self] data in
            guard let self else { return }
            if data {
                self.currencyInputView.showButton()
                self.currencyOutputView.showButton()
            }
        }
        
        createList()
    }
    
    // MARK: Functions to add UI elements
    
    func addReverseButton() {
        view.addSubview(reverseButton)
        
        NSLayoutConstraint.activate([
            reverseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            reverseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reverseButton.heightAnchor.constraint(equalToConstant: 50),
            reverseButton.widthAnchor.constraint(equalToConstant: 50),
        ])
        
        reverseButton.addTarget(self, action: #selector(reverse), for: .touchUpInside)
    }
    
    @objc func reverse() {
        (viewModel.currency.value, viewModel.toGetCurrency.value) = (viewModel.toGetCurrency.value, viewModel.currency.value)
        (viewModel.quantity.value, viewModel.output.value) = (viewModel.output.value, viewModel.quantity.value)
        viewModel.calculate()
    }
    
    func addInputAndOutputViews() {
        currencyInputView = InputOutputView(backgroundColor: view.backgroundColor)
        currencyOutputView = InputOutputView(backgroundColor: view.backgroundColor)
        view.addSubview(currencyInputView)
        currencyInputView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currencyOutputView)
        currencyOutputView.translatesAutoresizingMaskIntoConstraints = false
        
        currencyOutputView.inputTextField.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            currencyInputView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currencyInputView.bottomAnchor.constraint(equalTo: reverseButton.topAnchor, constant: -10),
            currencyInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            currencyInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            currencyInputView.heightAnchor.constraint(equalToConstant: 100),
            
            currencyOutputView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currencyOutputView.topAnchor.constraint(equalTo: reverseButton.bottomAnchor, constant: 10),
            currencyOutputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            currencyOutputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            currencyOutputView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        currencyInputView.button.tag = 0
        currencyOutputView.button.tag = 1
        currencyInputView.inputTextField.addTarget(self, action: #selector(textFieldInputChanged), for: .allEditingEvents)
    }
    
    @objc func textFieldInputChanged(sender: UITextField) {
        guard let quantity = sender.text else {
            viewModel.quantity.value = "0"
            viewModel.calculate()
            return
        }
        
        if !quantity.isEmpty {
            viewModel.quantity.value = quantity
            viewModel.calculate()
        }
    }
    
    // MARK: Bindings for view model properties
    
    func addBindings() {
        viewModel.currency.valueChanged = { [weak self] newValue in
            guard let self else { return }
            if let newValue = newValue {
                self.currencyInputView.currencyNameLabel.changeText(to: newValue)
                self.currencyInputView.showNameLabel()
            }
        }
        
        viewModel.toGetCurrency.valueChanged = { [weak self] newValue in
            guard let self else { return }
            if let newValue = newValue {
                self.currencyOutputView.currencyNameLabel.changeText(to: newValue)
                self.currencyOutputView.showNameLabel()
            }
        }
        
        viewModel.output.valueChanged = { [weak self] newValue in
            guard let self else { return }
            self.currencyOutputView.inputTextField.text = newValue
        }
        
        viewModel.quantity.valueChanged = { [weak self] newValue in
            guard let self else { return }
            self.currencyInputView.inputTextField.text = newValue
        }
        
        viewModel.errorObservable.valueChanged = { [weak self] newValue in
            guard let self else { return }
            var alertMessage: String!
            if let alertError = newValue as? InputError {
                alertMessage = alertError.rawValue
            } else {
                alertMessage = (newValue as? NetworkError)?.rawValue
            }
            
            let alertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
            DispatchQueue.main.async {
                self.currencyInputView.endEditing(true)
                self.present(alertController, animated: true)
            }
        }
    }
    
    // MARK: Functions to handle keyboard actions
    
    private func addObserversForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 1, delay: 0) {
                self.view.frame.origin.y = -keyboardSize.height / 2.5
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 1, delay: 0) {
            self.view.frame.origin.y = 0
        }
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: List of currencies
    
    func createList() {
        currencyInputView.button.addTarget(self, action: #selector(showList), for: .touchUpInside)
        currencyOutputView.button.addTarget(self, action: #selector(showList), for: .touchUpInside)
    }
    
    @objc func showList(caller: UIButton) {
        let controller = UIAlertController(title: "Choose currency", message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        viewModel.getNamesAndCodes().forEach { name in
            controller.addAction(UIAlertAction(title: name.key, style: .default, handler: { [weak self] alert in
                guard let self = self else { return }
                if caller.tag == 0 {
                    self.currencyInputView.hideNameLabelWithoutAnimation()
                    self.viewModel.currency.value = name.value
                } else {
                    self.currencyOutputView.hideNameLabelWithoutAnimation()
                    self.viewModel.toGetCurrency.value = name.value
                }
            }))
        }
        
        present(controller, animated: true)
    }
}


