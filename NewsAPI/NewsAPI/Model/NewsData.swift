//
//  NewsData.swift
//  NewsAPI
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//

import Foundation

struct NewsResponse: Decodable {
    let articles: [NewsData]
}

struct NewsData: Decodable {
    var author: String?
    var title: String?
    var description: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    var url: String?
}
