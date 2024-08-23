//
//  ViewController.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2023/07/11.
//

import UIKit
import MaterialActivityIndicator

class NewsViewController: UIViewController, SettingsViewControllerDelegate {
    
    let viewModel = NewsViewModel()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        handleRegisterCell()
        fetchNews()
        listenForNewsArticlesFetched()
        listenForSearchedArticles()
        updateSettingsButton()
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
       
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        let profileButton = UIButton(type: .custom)
        profileButton.setImage(getProfileImage()?.circleImage(), for: .normal)
        profileButton.frame = containerView.bounds
        profileButton.layer.cornerRadius = 20
        profileButton.layer.masksToBounds = true
        profileButton.addTarget(self, action: #selector(openUserProfile), for: .touchUpInside)
        
        containerView.addSubview(profileButton)
        
        let profileBarButtonItem = UIBarButtonItem(customView: containerView)
        navigationItem.leftBarButtonItem = profileBarButtonItem
        
        /*
         self.title = "News"
         guard let navigationBar = navigationController?.navigationBar else { return }
         navigationBar.backgroundColor = .white
         navigationBar.prefersLargeTitles = false
         navigationItem.searchController = searchController
         navigationController?.setStatusBar(backgroundColor: .white)
         
         // Custom title styling
         let titleAttributes: [NSAttributedString.Key: Any] = [
         .font: UIFont.systemFont(ofSize: 24, weight: .bold),
         .foregroundColor: UIColor.black
         ]
         navigationBar.titleTextAttributes = titleAttributes
         navigationBar.largeTitleTextAttributes = titleAttributes
         */
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
        
        newsTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
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
    
    func updateSettingsButton() {
        let selectedCountry = viewModel.selectedCountry
        let flagImage = UIImage(named: "flag_\(selectedCountry.rawValue)")?.withRenderingMode(.alwaysOriginal)
        let settingsButton = UIBarButtonItem(image: flagImage,
                                             style: .plain,
                                             target: self,
                                             action: #selector(openSettings))
        settingsButton.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: -10, right: -40)
        navigationItem.rightBarButtonItem = settingsButton
    }
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



