//
//  NewViewModel.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/01.
//

import Foundation

class NewsViewModel {
    
    var selectedCagory: NewsCategories = .general
    
    let categories: [NewsCategories] = [.general, .business, .sports, .politics, .technology, .health, .science, .entertainment, .weather]
    let countries: [NewsCountry] = [.za, .us, .gb, .ca, .ch, .fr, .ru, .ae, .ar, .at, .au, .be, .bg, .br, .cn, .co, .cu, .cz, .de, .eg, .gr, .hk, .hu, .id, .ie, .il, .india, .it, .jp, .kr, .lt, .lv, .ma, .mx, .my, .ng, .nl, .no, .nz, .ph, .pl, .pt, .ro, .rs, .se, .sg, .si, .sk, .th, .tr, .tw, .ua, .ve]
    
    // Cache for storing articles by category
    private var categoryArticlesCache: [NewsCategories: [Article]] = [:]
    
    /**
     - Search News Data
     */
    var isSearching = false
    var searchedArticles: [Article] = []
    var didSearchArticles: (([Article]?) -> Void)?
    
    var searchQuery: String = "" {
        didSet {
            if searchQuery.isEmpty {
                self.isSearching = false
                self.searchedArticles.removeAll()
            }
            if !self.articles.isEmpty {
                let searchedArticles = self.articles.filter({ (article: Article) -> Bool in
                    return article.title?.lowercased().contains(searchQuery.lowercased()) ?? false
                })
                self.searchedArticles = searchedArticles
                self.didSearchArticles?(searchedArticles)
            }
        }
    }
    
    /**
     - Fetch News Data
     */
    var articles: [Article] = []
    var didFetchArticles: (([Article]?) -> Void)?
    var parallaxHeaderArticle: Article?
    
    /*
     - Everythign Variable
     */
    var topHeadlinesArticles: [Article] = []
    
    /**
     Computed Propperties (variable that return something)
     */
    var selectedCountry: NewsCountry {
        /*
        if let country = UserDefaultsManager.shared.fetchValue(withKey: .country) {
            guard let countryString = country as? String else {
                return .za
            }
            return NewsCountry(rawValue: countryString) ?? .za
        }
        */
        if let country = UserDefaultsManager.shared.fetchValue(withKey: .country),
           let countryString = country as? String {
            return NewsCountry(rawValue: countryString) ?? .za
        }
        return .za
    }
    
    /**
     Computed Properties Example
     */
    var a = 29
    var b: Int {
        let g = 90
        let f = 79
        let division = 10 / 4
        return (g + f) * division
    }
    
    func addValueToB(f: Int, y: String) -> Int {
        let g = 90
//        let f = 79
        let division = 10 / 4
        return (g + f) * division
    }
    
    func fetchTopHeadlinesNewsData(category: NewsCategories) {
        // Check if the cache should be ignored (e.g., when the country changes)
        let shouldIgnoreCache = categoryArticlesCache[category]?.first?.source?.name != selectedCountry.rawValue
        
        if !shouldIgnoreCache, let cachedArticles = categoryArticlesCache[category] {
            print("Loaded cached articles for category: \(category.rawValue)")
            self.articles = cachedArticles
            self.didFetchArticles?(cachedArticles)
        } else {
            // If not cached, fetch from network
            let path = "\(NewsType.topHeadlines.rawValue)?country=\(selectedCountry.rawValue)&category=\(category.rawValue)"
            NewsService.shared.fetchData(method: .GET, baseURl: .newsUrl, path: path, model: NewsModel.self) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let news):
                        self.articles = news.articles ?? []
                        self.categoryArticlesCache[category] = news.articles ?? []
                        self.didFetchArticles?(news.articles)
                        print("Fetched and cached articles for category: \(category.rawValue)")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func fetchEverythingNews(category: NewsCategories) {
        
        let searchValue = getSingleWord(forCategory: category, andCountry: selectedCountry)
        let path = "\(NewsType.everything.rawValue)?q=\(searchValue)"
        NewsService.shared.fetchData(method: .GET, baseURl: .newsUrl, path: path, model: NewsModel.self) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let news):
                    self.topHeadlinesArticles = news.articles ?? []
                    self.parallaxHeaderArticle = news.articles?.first
                    self.didFetchArticles?(news.articles)
                    print("Fetched and cached articles for category: \(category.rawValue)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getSingleWord(forCategory category: NewsCategories, andCountry country: NewsCountry) -> String {
        switch (category, country) {
        // Sports
        case (.sports, .us):
            return "lebron-james"
        case (.sports, .gb):
            return "premier-league"
        case (.sports, .br):
            return "neymar"
        case (.sports, .za):
            return "springboks"
        case (.sports, .ru):
            return "khabib"
        case (.sports, .au):
            return "aussie-rules"
        case (.sports, .india):
            return "cricket"
        case (.sports, .jp):
            return "sumo"
        case (.sports, .de):
            return "bundesliga"
        case (.sports, .fr):
            return "tour-de-france"
        case (.sports, .it):
            return "serie-a"
        case (.sports, .ca):
            return "nhl"
        case (.sports, .ng):
            return "super-eagles"
        case (.sports, .cn):
            return "table-tennis"
        case (.sports, .gr):
            return "olympics"
        case (.sports, .mx):
            return "lucha-libre"

        // Technology
        case (.technology, .us):
            return "silicon-valley"
        case (.technology, .jp):
            return "sony"
        case (.technology, .kr):
            return "samsung"
        case (.technology, .cn):
            return "huawei"
        case (.technology, .india):
            return "infosys"
        case (.technology, .de):
            return "sap"
        case (.technology, .fr):
            return "alcatel"
        case (.technology, .gb):
            return "arm"
        case (.technology, .za):
            return "naspers"
        case (.technology, .il):
            return "intel"
        case (.technology, .sg):
            return "singtel"
        case (.technology, .au):
            return "atlassian"
        case (.technology, .tw):
            return "tsmc"
        case (.technology, .br):
            return "mercado-livre"
        case (.technology, .mx):
            return "banco-azteca"

        // Entertainment
        case (.entertainment, .us):
            return "hollywood"
        case (.entertainment, .india):
            return "bollywood"
        case (.entertainment, .fr):
            return "cannes"
        case (.entertainment, .gb):
            return "west-end"
        case (.entertainment, .kr):
            return "k-pop"
        case (.entertainment, .mx):
            return "telenovelas"
        case (.entertainment, .jp):
            return "anime"
        case (.entertainment, .it):
            return "venice-film-festival"
        case (.entertainment, .ru):
            return "ballet"
        case (.entertainment, .za):
            return "mama-awards"
        case (.entertainment, .ng):
            return "nollywood"
        case (.entertainment, .br):
            return "carnaval"
        case (.entertainment, .de):
            return "berlinale"
        case (.entertainment, .cn):
            return "chinese-opera"
        case (.entertainment, .tr):
            return "turkish-dramas"
        case (.entertainment, .ae):
            return "dubai-film-festival"

        // Business
        case (.business, .us):
            return "wall-street"
        case (.business, .cn):
            return "alibaba"
        case (.business, .de):
            return "volkswagen"
        case (.business, .jp):
            return "toyota"
        case (.business, .india):
            return "reliance"
        case (.business, .gb):
            return "london-stock-exchange"
        case (.business, .fr):
            return "lvmh"
        case (.business, .it):
            return "fiat"
        case (.business, .za):
            return "shoprite"
        case (.business, .br):
            return "petrobras"
        case (.business, .ca):
            return "canadian-tire"
        case (.business, .kr):
            return "hyundai"
        case (.business, .ru):
            return "gazprom"
        case (.business, .mx):
            return "pemex"
        case (.business, .au):
            return "bhp"
        case (.business, .sg):
            return "dbs"
        case (.business, .tw):
            return "foxconn"

        // Health
        case (.health, .us):
            return "cdc"
        case (.health, .india):
            return "ayurveda"
        case (.health, .za):
            return "discovery"
        case (.health, .gb):
            return "nhs"
        case (.health, .de):
            return "roche"
        case (.health, .fr):
            return "sanofi"
        case (.health, .jp):
            return "shiseido"
        case (.health, .cn):
            return "traditional-chinese-medicine"
        case (.health, .kr):
            return "cosmetic-surgery"
        case (.health, .au):
            return "medicare"
        case (.health, .br):
            return "sus"
        case (.health, .ca):
            return "canada-health"
        case (.health, .ru):
            return "sputnik-v"
        case (.health, .it):
            return "italian-health-service"
        case (.health, .ng):
            return "ncdc"
        case (.health, .mx):
            return "imss"
        case (.health, .eg):
            return "egypt-health-service"
        case (.health, .il):
            return "teva"

        // Science
        case (.science, .ru):
            return "roscosmos"
        case (.science, .us):
            return "nasa"
        case (.science, .cn):
            return "tiangong"
        case (.science, .jp):
            return "jaxa"
        case (.science, .india):
            return "isro"
        case (.science, .ae):
            return "cern"
        case (.science, .de):
            return "max-planck"
        case (.science, .fr):
            return "pasteur-institute"
        case (.science, .gb):
            return "oxford"
        case (.science, .it):
            return "galileo"
        case (.science, .au):
            return "csiro"
        case (.science, .ca):
            return "csa"
        case (.science, .br):
            return "embrapa"
        case (.science, .za):
            return "ska"
        case (.science, .kr):
            return "korea-aerospace"
        case (.science, .il):
            return "weizmann"

        // Politics
        case (.politics, .us):
            return "congress"
        case (.politics, .ru):
            return "kremlin"
        case (.politics, .cn):
            return "beijing"
        case (.politics, .gb):
            return "brexit"
        case (.politics, .fr):
            return "macron"
        case (.politics, .za):
            return "ramaphosa"
        case (.politics, .india):
            return "parliament"
        case (.politics, .br):
            return "bolsonaro"
        case (.politics, .de):
            return "bundestag"
        case (.politics, .it):
            return "quirinale"
        case (.politics, .jp):
            return "diet"
        case (.politics, .mx):
            return "amlo"
        case (.politics, .ca):
            return "parliament-hill"
        case (.politics, .au):
            return "canberra"
        case (.politics, .kr):
            return "blue-house"
        case (.politics, .ng):
            return "aso-rock"
        case (.politics, .eg):
            return "sisi"
        case (.politics, .gr):
            return "tsipras"
        case (.politics, .pl):
            return "duda"
        case (.politics, .ro):
            return "iohannis"
        case (.politics, .cz):
            return "prague-castle"
        case (.politics, .pt):
            return "republic-assembly"
        case (.politics, .rs):
            return "vucic"
        case (.politics, .se):
            return "riksdag"
        case (.politics, .bg):
            return "radev"
        case (.politics, .hu):
            return "orban"
        case (.politics, .at):
            return "vdb"

        // General
        case (.general, .za):
            return "Vodacom"
        case (.general, .fr):
            return "eiffel"
        case (.general, .jp):
            return "sakura"
        case (.general, .it):
            return "colosseum"
        case (.general, .eg):
            return "pyramids"
        case (.general, .india):
            return "taj-mahal"
        case (.general, .br):
            return "carnival"
        case (.general, .cn):
            return "great-wall"
        case (.general, .ru):
            return "red-square"
        case (.general, .us):
            return "freedom"
        case (.general, .au):
            return "sydney-opera-house"
        case (.general, .mx):
            return "chichen-itza"
        case (.general, .gr):
            return "acropolis"
        case (.general, .gb):
            return "big-ben"
        case (.general, .kr):
            return "seoul-tower"
        case (.general, .ca):
            return "niagara-falls"
        case (.general, .tr):
            return "hagia-sophia"
        case (.general, .ng):
            return "nollywood"
        case (.general, .il):
            return "western-wall"
        case (.general, .lt):
            return "vilnius"
        case (.general, .lv):
            return "riga"
        case (.general, .ma):
            return "marrakech"
        case (.general, .my):
            return "petronas-towers"
        case (.general, .nl):
            return "windmills"
        case (.general, .no):
            return "fjords"
        case (.general, .nz):
            return "hobbiton"
        case (.general, .ph):
            return "jeepney"
        case (.general, .pl):
            return "warsaw"
        case (.general, .ro):
            return "transylvania"
        case (.general, .rs):
            return "belgrade"
        case (.general, .se):
            return "stockholm"
        case (.general, .sg):
            return "merlion"
        case (.general, .si):
            return "bled"
        case (.general, .sk):
            return "bratislava"
        case (.general, .th):
            return "bangkok"
        case (.general, .tw):
            return "taipei-101"
        case (.general, .ua):
            return "kiev"
        case (.general, .ve):
            return "angel-falls"

        default:
            return "news"
        }
    }
}
