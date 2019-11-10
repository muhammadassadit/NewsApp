//
//  ViewModel.swift
//  NewsAPI
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//

import Foundation

protocol ViewModelDelegate: class {
    func updateView()
}

final class ViewModel {
    
    private(set) var fetchingMore: Bool = false
    
    var topNews = [NewsData]() {
        didSet {
            delegate?.updateView()
        }
    }
    
    var otherNews = [NewsData]() {
        didSet {
            delegate?.updateView()
        }
    }
    
    var currentNewsData: NewsData!
    
    weak var delegate: ViewModelDelegate?
    
    
    func getNews(pg: Int, size: Int) {
        NewsService.shared.downloadTopNews(page: pg, size: size) { [unowned self] result in
            switch result {
            case .success(let allNews):
                self.fetchingMore = true
                switch allNews.top.isEmpty {
                case true:
                    self.otherNews += allNews.other
                    self.fetchingMore = false
                case false:
                    self.topNews = allNews.top
                }
                self.otherNews = allNews.other
            case .failure(let error):
                print("Error Getting News: \(error.localizedDescription)")
            }
        }
    }
    
}

