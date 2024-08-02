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
        searchController.searchBar.placeholder = "search by transaction or date"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.backgroundColor = UIColor.groupTableViewBackground
        searchController.searchBar.tintColor = UIColor.black
        searchController.hidesNavigationBarDuringPresentation = true
        return searchController
    }()
    
    lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 40)
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.cellID)
        return collectionView
    }()
    
    lazy var newsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refreshControl
        tableView.backgroundColor = .white
        return tableView
    }()
    
    let refreshControl = UIRefreshControl()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        setupUI()
        setupNavigationBar()
        setupFilterButton()
        handleRegisterCell()
        fetchNews()
        listenForNewsArticlesFetched()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.title = "News"
        guard let navigationBar = navigationController?.navigationBar else { return }
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.searchController = searchController
        navigationController?.setStatusBar(backgroundColor: .white)
        
        // Custom title styling
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: UIColor.black
        ]
        navigationBar.titleTextAttributes = titleAttributes
        navigationBar.largeTitleTextAttributes = titleAttributes
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(categoryCollectionView)
        view.addSubview(newsTableView)
        view.addSubview(loadingIndicator)
        
        
        categoryCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        categoryCollectionView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        newsTableView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 5).isActive = true
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
    
    @objc func refreshNews() {
        let selectedCategory = viewModel.categories[categoryCollectionView.indexPathsForSelectedItems?.first?.item ?? 0]
        fetchNewsForCategory(selectedCategory)
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
