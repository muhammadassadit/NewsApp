//
//  ViewController.swift
//  NewsAPI
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    private var pageNumber = 1
    private let pageSize = 10
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()
    }
    
    func configureRefreshControl () {
       // Add the refresh control to your UIScrollView object.
       tableView.refreshControl = UIRefreshControl()
       tableView.refreshControl?.addTarget(self, action:
                                          #selector(handleRefreshControl),
                                          for: .valueChanged)
    }
    
    private func setupVC() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.getNews(pg: pageNumber, size: pageSize)
        pageNumber += 1
        viewModel.getNews(pg: pageNumber, size: pageSize)
    }
        
    @objc func handleRefreshControl() {
       // Update your content…
       // Dismiss the refresh control.
       DispatchQueue.main.async {
          self.tableView.refreshControl?.endRefreshing()
       }
    }
    
    

}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.topNews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopNewsCell", for: indexPath) as! NewsCollectionViewCell
        
        let currNews = viewModel.topNews[indexPath.row]
        cell.data = currNews
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ReadNewsViewController") as! ReadNewsViewController
        let currNews = viewModel.topNews[indexPath.row]
        viewModel.currentNewsData = currNews
        viewController.viewModel = self.viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.otherNews.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as! NewsTableViewCell
        
        let otherNew = viewModel.otherNews[indexPath.row]
        cell.data = otherNew
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ReadNewsViewController") as! ReadNewsViewController
        
        if let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell {
            cell.isSelected = false
        }
        
        let otherNew = viewModel.otherNews[indexPath.row]
        viewModel.currentNewsData = otherNew
        viewController.viewModel = self.viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !viewModel.fetchingMore {
            if indexPath.row == viewModel.otherNews.count - 1 {
                pageNumber += 1
                viewModel.getNews(pg: pageNumber, size: pageSize)
            }
        }
    }
    
}


extension ViewController: ViewModelDelegate {
    func updateView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
    }
}
