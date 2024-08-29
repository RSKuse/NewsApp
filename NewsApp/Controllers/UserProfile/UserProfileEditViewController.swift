//
//  UserProfileEditViewController.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/29.
//

import Foundation
import UIKit

protocol UserProfileEditDelegate: AnyObject {
    func didSaveProfile(_ profileInfo: [String: Any])
}

class UserProfileEditViewController: UIViewController {
    weak var delegate: UserProfileEditDelegate?

    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your name"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground // Adapt to dark mode
        textField.textColor = .label // Adapt to dark mode
        return textField
    }()

    lazy var ageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your age"
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground // Adapt to dark mode
        textField.textColor = .label // Adapt to dark mode
        return textField
    }()

    lazy var genderSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Male", "Female", "Other"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    lazy var bioTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 8
        textView.backgroundColor = .systemBackground // Adapt to dark mode
        textView.textColor = .label // Adapt to dark mode
        return textView
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground // Adapt to dark mode
        setupUI()
        setupTapGesture()
        registerKeyboardNotifications()
    }

    private func setupUI() {
        view.addSubview(nameTextField)
        view.addSubview(ageTextField)
        view.addSubview(genderSegmentedControl)
        view.addSubview(bioTextView)
        view.addSubview(saveButton)

        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        ageTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        ageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        ageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        ageTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        genderSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        genderSegmentedControl.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 20).isActive = true
        genderSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        genderSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        bioTextView.topAnchor.constraint(equalTo: genderSegmentedControl.bottomAnchor, constant: 20).isActive = true
        bioTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        bioTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        bioTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 20).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height

        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        
    }

    @objc private func saveProfile() {
        let profileInfo: [String: Any] = [
            "name": nameTextField.text ?? "",
            "age": ageTextField.text ?? "",
            "gender": genderSegmentedControl.selectedSegmentIndex,
            "bio": bioTextView.text ?? ""
        ]
        UserDefaults.standard.set(profileInfo, forKey: "userProfile")
        delegate?.didSaveProfile(profileInfo)
        navigationController?.popViewController(animated: true)
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder() // Dismiss the keyboard when done editing the text view
    }
    
}
