//
//  ViewController.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2023/07/11.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var articles: [Article]? {
        didSet {
            guard let _ = articles else { return }
            filteredArticles = articles
            newsTableView.reloadData()
        }
    }
    
    var filteredArticles: [Article]?

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
        return searchBar
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleRegisterCell()
        fetchNews()
    }
    
    func setupUI() {
        view.addSubview(newsTableView)
        view.addSubview(loadingIndicator)
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            newsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            newsTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            newsTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            newsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        refreshControl.addTarget(self, action: #selector(fetchNews), for: .valueChanged)
    }
    
    func handleRegisterCell() {
        newsTableView.register(NewsAppTableViewCell.self, forCellReuseIdentifier: "NewsAppTableViewCellID")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArticles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let newsCell = tableView.dequeueReusableCell(withIdentifier: "NewsAppTableViewCellID", for: indexPath) as? NewsAppTableViewCell, let articles = filteredArticles else {
            return UITableViewCell()
        }
        
        let newsArticle = articles[indexPath.row]
        newsCell.configure(with: newsArticle)
        newsCell.likeImageButton.tag = indexPath.row
        newsCell.likeImageButton.addTarget(self, action: #selector(handleLikeButtonTapped(sender:)), for: .touchUpInside)
        return newsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articles = filteredArticles else { return }
        let article = articles[indexPath.row]
        if let urlString = article.url, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func fetchNews() {
        loadingIndicator.startAnimating()
        NewsService.shared.fetchNews { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
                switch result {
                case .success(let articles):
                    self?.articles = articles
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let articles = articles else { return }
        
        if searchText.isEmpty {
            filteredArticles = articles
        } else {
            filteredArticles = articles.filter { $0.title?.lowercased().contains(searchText.lowercased()) == true }
        }
        
        newsTableView.reloadData()
    }
    
    @objc func handleLikeButtonTapped(sender: UIButton) {
        let articleIndex = sender.tag
        filteredArticles?[articleIndex].likesCount? += 1
        newsTableView.reloadData()
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
