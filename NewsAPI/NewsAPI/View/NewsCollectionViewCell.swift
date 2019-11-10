//
//  NewsCollectionViewCell.swift
//  NewsAPI
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//

import UIKit

//user interface 

class NewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lable: UILabel!
    
    var imageUrlString: String = ""
    var data: NewsData? {
        didSet {
            // Visual settings
            imageView.image = nil
            self.layer.cornerRadius = 10
            
            lable.text = data?.title
            
            if data?.urlToImage == nil { return }
            
            let urlString = data!.urlToImage!
            let url = URL(string: urlString)
            
            self.imageUrlString = urlString
            
            if let imageFromCache = imageCache.object(forKey: NSString(string: urlString)) {
                imageView.image = imageFromCache
            } else {
                URLSession.shared.dataTask(with: url!) { (data, responder, error) in
                    if error != nil {
                        print(error as Any)
                        return
                    }
                    DispatchQueue.main.async {
                        let imageToCache = UIImage(data: data!)?.resizeImage(newWidth: self.frame.width)
                        if self.imageUrlString == urlString {
                            self.imageView.image = imageToCache
                        }
                        imageCache.setObject(imageToCache!, forKey: NSString(string: urlString))
                    }
                }.resume()
            }
            
        }
    }
}
