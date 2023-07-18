//
//  ViewController.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2023/07/11.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let newsBulletinDatabase = NewsBulletinDatabase()

    
    lazy var newsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleRegisterCell()
    }
    
    func setupUI() {
        view.addSubview(newsTableView)
        
        newsTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        newsTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        newsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        newsTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    func handleRegisterCell() {
        newsTableView.register(NewsAppTableViewCell.self, forCellReuseIdentifier: "NewsAppTableViewCellID")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsBulletinDatabase.newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsCell = tableView.dequeueReusableCell(withIdentifier: "NewsAppTableViewCellID",for: indexPath) as! NewsAppTableViewCell
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
        return newsCell
    }
    
}

