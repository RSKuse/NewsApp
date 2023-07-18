//
//  NewsBulletin.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2023/07/16.
//

import Foundation
import UIKit

class NewsBulletinDatabase {
    var newsArray: [NewsApp] = [NewsApp(newsCompanyImage: UIImage(named: "design_boom")!,
                                        newsCompanyName: "Design Boom",
                                        lastBulletinNewsTimeStamp: "3h",
                                        newsBulletinImage: UIImage(named: "greek")!,
                                        newsBulletin: "Greek 'villa earth' emerges from the mediterranean coast like a futuristic yacht",
                                        likesCount: 1,
                                        commentCount: 0,
                                        readCount: 42),
                                NewsApp(newsCompanyImage: UIImage(named: "BGR")!,
                                            newsCompanyName: "BGR",
                                            lastBulletinNewsTimeStamp: "2d",
                                            newsBulletinImage: UIImage(named: "beta")!,
                                            newsBulletin: "How to join the Threads beta program and get new features early",
                                            likesCount: 14,
                                            commentCount: 2,
                                            readCount: 1226),
                                NewsApp(newsCompanyImage: UIImage(named: "insider")!,
                                            newsCompanyName: "Insider",
                                            lastBulletinNewsTimeStamp: "2d",
                                            newsBulletinImage: UIImage(named: "twitter")!,
                                            newsBulletin: "Twitter was hit with a massive $90 million legal fee that Elon Musk is now trying to fight in court. A former Twitter director saw the bill and responded, 'O My Freaking God,' court documents show.",
                                            likesCount: 4,
                                            commentCount: 4,
                                            readCount: 1),
                                NewsApp(newsCompanyImage: UIImage(named: "tech_crunch")!,
                                            newsCompanyName: "TechCrunch",
                                            lastBulletinNewsTimeStamp: "1d",
                                            newsBulletinImage: UIImage(named: "ai")!,
                                            newsBulletin: "The week in Al: Generative Al spams up the web by Kyle Wiggers",
                                            likesCount: 10,
                                            commentCount: 4,
                                            readCount: 0),
    
    ]
}



