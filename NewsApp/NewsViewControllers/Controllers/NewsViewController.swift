//
//  ViewController.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2023/07/11.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let viewModel = NewsViewModel()
    
    lazy var newsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    let refreshControl = UIRefreshControl()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search news..."
        searchBar.isHidden = true
        return searchBar
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // or .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
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
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setStatusBar(backgroundColor: .white)
    }
    
    
    func setupUI() {
        view.addSubview(newsTableView)
        view.addSubview(loadingIndicator)
//        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
//            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
//            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            newsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            newsTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            newsTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            newsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        refreshControl.addTarget(self, action: #selector(fetchNews), for: .valueChanged)
    }
    
    func handleRegisterCell() {
        newsTableView.register(NewsAppTableViewCell.self, forCellReuseIdentifier: NewsAppTableViewCell.cellID)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /*
        guard let articles = articles else { return }
        
        if searchText.isEmpty {
            filteredArticles = articles
        } else {
            filteredArticles = articles.filter { $0.title?.lowercased().contains(searchText.lowercased()) == true }
        }
        
        newsTableView.reloadData()
        */
    }
}

/*
 //    let newsBulletinDatabase = NewsBulletinDatabase()
let news = newsBulletinDatabase.newsArray[indexPath.row]

newsCell.newsAppImageView.image = news.newsCompanyImage
newsCell.newsCompanyNameLabel.text = news.newsCompanyName
newsCell.timeStampLabel.text = news.lastBulletinNewsTimeStamp
newsCell.newsBulletinImageView.image = news.newsBulletinImage
newsCell.newsBulletinDetailLabel.text = news.newsBulletin

var likeCommentRead = ""

if news.likesCount == 0 {
    likeCommentRead = ""
    
} else if news.likesCount == 1 {
    likeCommentRead = "\(news.likesCount) like"
    
} else {
    likeCommentRead += "\(news.likesCount) likes"
}

if news.commentCount == 0 {
    //likeCommentRead = "\(news.likesCount) likes"
    
} else if news.commentCount == 1 {
    likeCommentRead += " • \(news.commentCount) comment"
    
} else {
    likeCommentRead += " • \(news.commentCount) comments"

}

if news.readCount == 0 {
    likeCommentRead += ""
    
} else if news.readCount == 1 {
    likeCommentRead += " • \(news.readCount) read"
        
} else {
    likeCommentRead += " • \(news.readCount) reads"
}

newsCell.likeCommentReadLabel.text = likeCommentRead
*/
