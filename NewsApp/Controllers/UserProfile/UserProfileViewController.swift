//
//  UserProfileViewController.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/17.
//

import Foundation
import Foundation
import UIKit

class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.image = UIImage(named: "profile_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your name"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.textColor = .black
        return textField
    }()
    
    lazy var ageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your age"
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.textColor = .black
        return textField
    }()
    
    lazy var genderSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Male", "Female", "Other"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentTintColor = UIColor.systemBlue
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        return segmentedControl
    }()
    
    lazy var bioTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Enter your bio here..."
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.textColor = .black
        return textView
    }()
    
//    lazy var saveButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Save", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        loadUserProfile()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeProfilePicture))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveProfile))
        
        // Dismissing keyboard when tapping outside textfields
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeyboardGesture)
    }
    
    func setupUI() {
        view.addSubview(profileImageView)
        view.addSubview(nameTextField)
        view.addSubview(ageTextField)
        view.addSubview(genderSegmentedControl)
        view.addSubview(bioTextView)
//        view.addSubview(saveButton)

        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true

        ageTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        ageTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        ageTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        ageTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true

        genderSegmentedControl.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 20).isActive = true
        genderSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        genderSegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true

        bioTextView.topAnchor.constraint(equalTo: genderSegmentedControl.bottomAnchor, constant: 20).isActive = true
        bioTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        bioTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        bioTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true

//        saveButton.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 20).isActive = true
//        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    @objc func saveProfile() {
        let userProfile = [
            "name": nameTextField.text ?? "",
            "age": ageTextField.text ?? "",
            "gender": genderSegmentedControl.selectedSegmentIndex,
            "bio": bioTextView.text ?? ""
        ] as [String : Any]
        
        if let imageData = profileImageView.image?.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(imageData, forKey: "profileImage")
        }
        UserDefaults.standard.set(userProfile, forKey: "userProfile")
        
        navigationController?.popViewController(animated: true)
    }
    
    func loadUserProfile() {
        if let userProfile = UserDefaults.standard.dictionary(forKey: "userProfile") {
            nameTextField.text = userProfile["name"] as? String
            ageTextField.text = userProfile["age"] as? String
            genderSegmentedControl.selectedSegmentIndex = userProfile["gender"] as? Int ?? 0
            bioTextView.text = userProfile["bio"] as? String
        }
        
        if let imageData = UserDefaults.standard.data(forKey: "profileImage") {
            profileImageView.image = UIImage(data: imageData)
        } else {
            
            profileImageView.image = UIImage(named: "profile_icon")?.circleImage()
            
        }
        // Load existing user data if available and populate the UI elements
    }
    func saveProfileImageToDisk(image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent("savedProfileImage.jpg")
            try? data.write(to: filename)
            print("Image saved at: \(filename.path)")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    @objc func changeProfilePicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
