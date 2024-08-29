import UIKit

class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Background Image View
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "background_image_placeholder")
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true // Enable interaction
        return imageView
    }()

    // Profile Image View
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.image = UIImage(named: "profile_icon")
        imageView.isUserInteractionEnabled = true // Enable interaction
        return imageView
    }()

    // Edit Profile Button
    lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupTapGestures()
        loadSavedImages()
    }

    private func setupUI() {
        // Add backgroundImageView to the view
        view.addSubview(backgroundImageView)
        view.addSubview(profileImageView)
        view.addSubview(editProfileButton)

        // Setup constraints for backgroundImageView
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true

        // Setup profileImageView to overlap with backgroundImageView
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: backgroundImageView.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        // Setup constraints for editProfileButton
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editProfileButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        editProfileButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        editProfileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    // Implementing the tap gestures for image views
    private func setupTapGestures() {
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(profileTapGesture)

        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundImageTapped))
        backgroundImageView.addGestureRecognizer(backgroundTapGesture)
    }

    @objc private func profileImageTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "View Profile Picture", style: .default, handler: { _ in
            // Code to view profile picture (This could navigate to a screen that displays the picture in full screen)
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
            // Code to view background image (This could navigate to a screen that displays the picture in full screen)
        }))
        alert.addAction(UIAlertAction(title: "Upload Background Image", style: .default, handler: { _ in
            self.showImagePicker(for: .backgroundImage)
        }))
        alert.addAction(UIAlertAction(title: "Create Collage", style: .default, handler: { _ in
            // Code to create a collage
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc private func editProfileTapped() {
        // Navigate to Edit Profile Screen
        let editProfileVC = UserProfileEditViewController()
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

    // To keep track of the image type being edited
    private enum ImageType {
        case profileImage, backgroundImage
    }
    private var currentImageType: ImageType?

    // MARK: - UIImagePickerControllerDelegate
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
                backgroundImageView.image = selectedImage
                saveImageToUserDefaults(image: selectedImage, key: "backgroundImage")
            }
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Saving and Loading Images
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
            backgroundImageView.image = backgroundImage
        }
    }
}
