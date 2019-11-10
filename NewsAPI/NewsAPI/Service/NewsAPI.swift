//
//  NewsAPI.swift
//  NewsAPI
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//

import Foundation

struct NewsAPI {
    
    private var pageSize: Int!
    private var page: Int!
    
    init(size: Int, pg: Int) {
        self.pageSize = size
        self.page = pg
    }
    private let key: String = "&apiKey=43d4dafc13c0421aa1ba8927cb185467"
    private let base = "https://newsapi.org/v2/top-headlines?country=us"
    
    
    var url: URL? {
        let endPoint = base + "&pageSize=\(pageSize!)" + "&page=\(page!)" + key
        return URL(string: endPoint)
    }
    
}
