
//
//  UserProfileViewController.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/29.
//


import UIKit
import ParallaxHeader

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UserProfileEditDelegate {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 70
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.systemBackground.cgColor // Adapt to dark mode
        imageView.image = UIImage(named: "profile_icon")
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.label, for: .normal) // Adapt to dark mode
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Georgia", size: 28)
        label.textAlignment = .left
        label.textColor = .label // Adapt to dark mode
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        label.textAlignment = .left
        label.textColor = .secondaryLabel // Adapt to dark mode
        label.text = "Age"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Georgia-Italic", size: 16)
        label.textAlignment = .left
        label.textColor = .secondaryLabel // Adapt to dark mode
        label.numberOfLines = 0
        label.text = "Bio"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameLabelAgeLabelAndBioLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, ageLabel,bioLabel])
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground // Adapt to dark mode
        setupTableView()
        setupParallaxHeader()
        setupTapGestures()
        setupUI()
        loadSavedImages()
        loadSavedProfileData()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    private func setupUI() {
        view.addSubview(nameLabelAgeLabelAndBioLabelStackView)
        
        nameLabelAgeLabelAndBioLabelStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nameLabelAgeLabelAndBioLabelStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        
    }
    
    private func setupParallaxHeader() {
        let parallaxHeaderView = UIImageView()
        parallaxHeaderView.image = UIImage(named: "background_image_placeholder")
        parallaxHeaderView.contentMode = .scaleAspectFill
        parallaxHeaderView.clipsToBounds = true
        
        tableView.parallaxHeader.view = parallaxHeaderView
        tableView.parallaxHeader.height = 300
        tableView.parallaxHeader.minimumHeight = 100
        tableView.parallaxHeader.mode = .fill
        
        parallaxHeaderView.addSubview(profileImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    private func setupTapGestures() {
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(profileTapGesture)
        
        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundImageTapped))
        if let parallaxView = tableView.parallaxHeader.view as? UIImageView {
            parallaxView.isUserInteractionEnabled = true
            parallaxView.addGestureRecognizer(backgroundTapGesture)
        }
    }
    
    @objc private func profileImageTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "View Profile Picture", style: .default, handler: { _ in
            self.viewImage(self.profileImageView.image)
        }))
        alert.addAction(UIAlertAction(title: "Upload Profile Picture", style: .default, handler: { _ in
            self.showImagePicker(for: .profileImage)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc private func backgroundImageTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "View Background Image", style: .default, handler: { _ in
            if let parallaxView = self.tableView.parallaxHeader.view as? UIImageView {
                self.viewImage(parallaxView.image)
            }
        }))
        alert.addAction(UIAlertAction(title: "Upload Background Image", style: .default, handler: { _ in
            self.showImagePicker(for: .backgroundImage)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func viewImage(_ image: UIImage?) {
        guard let image = image else { return }

        let imageViewController = ImageViewController()
        imageViewController.image = image

        // Embed the ImageViewController in a UINavigationController
        let navigationController = UINavigationController(rootViewController: imageViewController)
        navigationController.modalPresentationStyle = .fullScreen

        present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func editProfileTapped() {
        let editProfileVC = UserProfileEditViewController()
        editProfileVC.delegate = self
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    // MARK: - Image Picker
    private func showImagePicker(for imageType: ImageType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
        
        self.currentImageType = imageType
    }
    
    private enum ImageType {
        case profileImage, backgroundImage
    }
    private var currentImageType: ImageType?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        if let imageType = currentImageType {
            switch imageType {
            case .profileImage:
                profileImageView.image = selectedImage
                saveImageToUserDefaults(image: selectedImage, key: "profileImage")
            case .backgroundImage:
                if let parallaxView = tableView.parallaxHeader.view as? UIImageView {
                    parallaxView.image = selectedImage
                }
                saveImageToUserDefaults(image: selectedImage, key: "backgroundImage")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func saveImageToUserDefaults(image: UIImage, key: String) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(imageData, forKey: key)
        }
    }
    
    private func loadSavedImages() {
        if let profileImageData = UserDefaults.standard.data(forKey: "profileImage"),
           let profileImage = UIImage(data: profileImageData) {
            profileImageView.image = profileImage
        }
        
        if let backgroundImageData = UserDefaults.standard.data(forKey: "backgroundImage"),
           let backgroundImage = UIImage(data: backgroundImageData) {
            if let parallaxView = tableView.parallaxHeader.view as? UIImageView {
                parallaxView.image = backgroundImage
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.contentView.addSubview(editProfileButton)

        editProfileButton.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: -20).isActive = true
        editProfileButton.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20).isActive = true
        editProfileButton.widthAnchor.constraint(equalToConstant: 115).isActive = true
        editProfileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        editProfileButton.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -20).isActive = true
        
        return cell
    }
    
    func didSaveProfile(_ profileInfo: [String: Any]) {
        if let name = profileInfo["name"] as? String {
            nameLabel.text = name
        }
        if let age = profileInfo["age"] as? String {
            ageLabel.text = "Age: \(age)"
        }
        if let bio = profileInfo["bio"] as? String {
            bioLabel.text = bio
        }
    }
    
    private func loadSavedProfileData() {
        if let profileInfo = UserDefaults.standard.dictionary(forKey: "userProfile") as? [String: Any] {
            if let name = profileInfo["name"] as? String {
                nameLabel.text = name
            }
            if let age = profileInfo["age"] as? String {
                ageLabel.text = "Age: \(age)"
            }
            if let bio = profileInfo["bio"] as? String {
                bioLabel.text = bio
            }
        }
    }
}
