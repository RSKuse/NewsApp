//
//  ViewController.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2023/07/11.
//

import UIKit

class NewsViewController: UIViewController {
    
    let viewModel = NewsViewModel()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "search by name or source"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.backgroundColor = UIColor.white
        searchController.searchBar.tintColor = UIColor.black
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
        setupFilterButton()
        handleRegisterCell()
        fetchNews()
        listenForNewsArticlesFetched()
        listenForSearchedArticles()
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
        
        setNavigationTitle(withTitle: "Goofy News")
        
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
    
    func setupFilterButton() {
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(showFilterOptions))
        navigationItem.rightBarButtonItem = filterButton
    }
    
    func handleRegisterCell() {
        newsTableView.register(NewsAppTableViewCell.self, forCellReuseIdentifier: NewsAppTableViewCell.cellID)
    }
    
    @objc func showFilterOptions() {
        // Present filter options
        let alertController = UIAlertController(title: "Filter", message: "Choose a country", preferredStyle: .actionSheet)
        
        for country in viewModel.countries {
            alertController.addAction(UIAlertAction(title: country.rawValue.uppercased(), style: .default, handler: { [weak self] _ in
                self?.fetchNewsForCountry(country)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
