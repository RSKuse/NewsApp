//
//  ViewController.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2023/07/11.
//

import UIKit
import MaterialActivityIndicator
import ParallaxHeader
import SafariServices

class NewsViewController: UIViewController, SettingsViewControllerDelegate {
    
    let viewModel = NewsViewModel()
    var parallaxHeaderArticle: Article?
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search by name or source"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.backgroundColor = UIColor.white
        searchController.searchBar.tintColor = UIColor.black
        
        // Set placeholder attributes
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let attributedPlaceholder = NSAttributedString(string: "Search by name or source", attributes: placeholderAttributes)
        searchController.searchBar.searchTextField.attributedPlaceholder = attributedPlaceholder
        
        // Ensure the text color is black
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = UIColor.black
            
            // Ensure the keyboard appearance is light
            textField.keyboardAppearance = .light
            
            if let leftIconView = textField.leftView as? UIImageView {
                leftIconView.tintColor = UIColor.lightGray
            }
        }
        
        // Ensure the text input trait reflects correctly in the dark mode as well
        searchController.searchBar.searchTextField.overrideUserInterfaceStyle = .light
        
        searchController.hidesNavigationBarDuringPresentation = true
        return searchController
    }()
    
    lazy var categoriesHeaderView: NewsCategoriesHeaderView = {
        let headerView = NewsCategoriesHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.categories = viewModel.categories
        headerView.didSelectCategory = { [weak self] category in
            self?.viewModel.selectedCagory = category
            self?.fetchNewsForCategory(category)
        }
        return headerView
    }()
    
    lazy var newsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.refreshControl = refreshControl
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let refreshControl = UIRefreshControl()
    
    lazy var loadingIndicator: MaterialActivityIndicatorView = {
        let indicator = MaterialActivityIndicatorView()
        indicator.color = .red
        indicator.lineWidth = 2.0
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var topHeaderlineImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var headlineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Georgia-BoldItalic", size: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 0.7
        label.layer.masksToBounds = false
 
        let strokeTextAttributes: [NSAttributedString.Key : Any] = [
            .strokeColor : UIColor.black,
            .foregroundColor : UIColor.white,
            .strokeWidth : -2.0
        ]
        label.attributedText = NSAttributedString(string: "Your Headline", attributes: strokeTextAttributes)
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupParallaxHeader()
        handleRegisterCell()
        fetchNews()
        listenForNewsArticlesFetched()
        listenForSearchedArticles()
        //updateSettingsButton()
    }
 
    func setupParallaxHeader() {
        topHeaderlineImageView.addSubview(headlineLabel)
        
        newsTableView.parallaxHeader.view = topHeaderlineImageView
        newsTableView.parallaxHeader.height = 400
        newsTableView.parallaxHeader.minimumHeight = 0
        newsTableView.parallaxHeader.mode = .topFill
        
        headlineLabel.leadingAnchor.constraint(equalTo: topHeaderlineImageView.leadingAnchor, constant: 16).isActive = true
        headlineLabel.trailingAnchor.constraint(equalTo: topHeaderlineImageView.trailingAnchor, constant: -16).isActive = true
        headlineLabel.bottomAnchor.constraint(equalTo: topHeaderlineImageView.bottomAnchor, constant: -16).isActive = true
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(parallaxHeaderTapped))
        topHeaderlineImageView.isUserInteractionEnabled = true
        topHeaderlineImageView.addGestureRecognizer(tapGesture)
    }

    @objc func parallaxHeaderTapped() {
        guard let urlString = viewModel.parallaxHeaderArticle?.url, // Use the stored article
              let url = URL(string: urlString) else {
            print("URL is nil or invalid") // Debugging line
            return
        }
        let safariController = SFSafariViewController(url: url)
        present(safariController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationNoLineBar()
        navigationController?.setStatusBar(backgroundColor: UIColor.white)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        setNavigationTitle(withTitle: "Your News Daily")
       
        let profileContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        let profileButton = UIButton(type: .custom)
        profileButton.setImage(getProfileImage()?.circleImage(), for: .normal)
        profileButton.frame = profileContainerView.bounds
        profileButton.layer.cornerRadius = 20
        profileButton.layer.masksToBounds = true
        profileButton.addTarget(self, action: #selector(openUserProfile), for: .touchUpInside)
        
        profileContainerView.addSubview(profileButton)
        
        let profileBarButtonItem = UIBarButtonItem(customView: profileContainerView)
        navigationItem.leftBarButtonItem = profileBarButtonItem
        

        let countrySelectionView = CountrySelectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        let selectedCountry = viewModel.selectedCountry
        //countrySelectionView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        let flagImage = UIImage(named: "flag_\(selectedCountry.rawValue)")
        countrySelectionView.configure(flag: flagImage, countryCode: selectedCountry.rawValue.uppercased())

        // Set the onTap closure to open the settings
        countrySelectionView.onTap = { [weak self] in
            print("Navigating to settings")
            self?.openSettings()
        }

        let countryBarButtonItem = UIBarButtonItem(customView: countrySelectionView)
        countrySelectionView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Re-assign the right bar button item
        navigationItem.rightBarButtonItem = nil
        navigationItem.rightBarButtonItem = countryBarButtonItem
    }
    
    @objc func openUserProfile() {
        let profileVC = UserProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func getProfileImage() -> UIImage? {
        if let imageData = UserDefaults.standard.data(forKey: "profileImage") {
            print("Image data found, creating UIImage")
            return UIImage(data: imageData)?.circleImage()
        } else {
            print("No image data found, returning placeholder")
            return UIImage(named: "profile_icon")?.circleImage()
        }
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(newsTableView)
        view.addSubview(loadingIndicator)
        view.addSubview(categoriesHeaderView) // Add this line
        
        // Set constraints for categoriesHeaderView
        categoriesHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        categoriesHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoriesHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        categoriesHeaderView.heightAnchor.constraint(equalToConstant: 50).isActive = true // Adjust height as needed
        
        newsTableView.topAnchor.constraint(equalTo: categoriesHeaderView.bottomAnchor).isActive = true
        newsTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        newsTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        newsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc func openSettings() {
        let settingsVC = SettingsViewController()
        settingsVC.delegate = self
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
//    func updateSettingsButton() {
//        let selectedCountry = viewModel.selectedCountry
//        let flagImage = UIImage(named: "flag_\(selectedCountry.rawValue)")?.withRenderingMode(.alwaysOriginal)
//        let settingsButton = UIBarButtonItem(image: flagImage,
//                                             style: .plain,
//                                             target: self,
//                                             action: #selector(openSettings))
//        settingsButton.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: -10, right: -40)
//        navigationItem.rightBarButtonItem = settingsButton
//    }
    func handleRegisterCell() {
        newsTableView.register(NewsAppTableViewCell.self, forCellReuseIdentifier: NewsAppTableViewCell.cellID)
    }
}

extension UIImage {

    func circleImage() -> UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: square))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = square.width / 2
        imageView.layer.masksToBounds = true
        imageView.image = self

        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
    
    
    
//    func setupFilterButton() {
//        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(showFilterOptions))
//        navigationItem.rightBarButtonItem = filterButton
//    }
    
    
//    @objc func showFilterOptions() {
//        // Present filter options
//        let alertController = UIAlertController(title: "Filter", message: "Choose a country", preferredStyle: .actionSheet)
//        
//        for country in viewModel.countries {
//            alertController.addAction(UIAlertAction(title: country.rawValue.uppercased(),
//                                                    style: .default,
//                                                    handler: { [weak self] _ in
//                UserDefaultStorage.country.storeValue(country.rawValue)
//                self?.fetchNewsForCountry()
//            }))
//        }
//        
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        
//        present(alertController, animated: true, completion: nil)
//    }

