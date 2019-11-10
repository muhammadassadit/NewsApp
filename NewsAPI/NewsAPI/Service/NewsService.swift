//
//  NewsService.swift
//  NewsAPI
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//

import Foundation

enum NewsError: Error {
    case missing(String)
    case empty(String)
}
typealias NewsHandler = (Result<(top: [NewsData], other: [NewsData]), NewsError>) -> Void

final class NewsService {
    
    static let shared = NewsService()
    private init() {}
    
    func downloadTopNews(page: Int, size: Int, completion: @escaping NewsHandler){
        
        guard let url = NewsAPI(size: size, pg: page).url else {
            completion(.failure(NewsError.empty("URL Could Not Be Formed")))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (dat, _, err) in
            if let error = err {
                completion(.failure(NewsError.missing(error.localizedDescription)))
                return
            }
            
            if let data = dat {
                
                do {
                    let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                    let news = response.articles
                    
                    var maximumPages = news.count / 10 // 10 news in tableView
                    if maximumPages % 10 > 0 {
                        maximumPages += 1
                    }
                    if page > maximumPages {
                        completion(.failure(NewsError.missing("Above Max Pages Allowed")))
                        return
                    }
                    
                    switch page == 1 {
                    case true:
                        completion(.success((top: news, other: [])))
                    case false:
                        completion(.success((top: [], other: news)))
                        
                    }
                } catch {
                    completion(.failure(NewsError.missing(error.localizedDescription)))
                    return
                }
                
            }
        }.resume()
    }
}
    
