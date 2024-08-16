//
//  ViewController.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2023/07/11.
//

import UIKit

class NewsViewController: UIViewController, SettingsViewControllerDelegate {
    
    let viewModel = NewsViewModel()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search by name or source"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.backgroundColor = UIColor.white
        searchController.searchBar.tintColor = UIColor.black
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let attributedPlaceholder = NSAttributedString(string: "Search by name or source", attributes: placeholderAttributes)
        searchController.searchBar.searchTextField.attributedPlaceholder = attributedPlaceholder
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField,
           let leftIconView = textField.leftView as? UIImageView {
            leftIconView.tintColor = UIColor.lightGray
        }
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
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
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
        
        //        setupFilterButton()
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
        settingsButton.imageInsets = UIEdgeInsets(top: 5, left: 10, bottom: -10, right: -40)
        navigationItem.rightBarButtonItem = settingsButton
    }
    func handleRegisterCell() {
        newsTableView.register(NewsAppTableViewCell.self, forCellReuseIdentifier: NewsAppTableViewCell.cellID)
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



