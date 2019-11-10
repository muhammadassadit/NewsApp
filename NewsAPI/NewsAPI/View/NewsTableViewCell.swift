//
//  NewsTableViewCell.swift
//  NewsAPI
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsThumb: UIImageView!
    
    @IBOutlet weak var blurDescriptionBackground: UIVisualEffectView!
    @IBOutlet weak var blurLabelBackground: UIVisualEffectView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var shortDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newsThumb.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var imageUrlString: String = ""
    var data: NewsData? {
        didSet {
            // Visual settings
            newsThumb.image = nil
            blurLabelBackground.layer.cornerRadius = 10
            blurLabelBackground.layer.maskedCorners = .init(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
            blurDescriptionBackground.layer.cornerRadius = 10
            blurDescriptionBackground.layer.maskedCorners = .init(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
            
            label.text = data?.title
            shortDescription.text = data?.description
            
            if data?.urlToImage == nil { return }
            
            let urlString = data!.urlToImage!
            guard let url = URL(string: urlString) else { return }
            
            imageUrlString = urlString
            
            if let imageFromCache = imageCache.object(forKey: NSString(string: urlString)) {
                newsThumb.image = imageFromCache
            }
            
            URLSession.shared.dataTask(with: url) { (data, responder, error) in
                if error != nil {
                    print(error as Any)
                    return
                }
                
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)?.resizeImage(newWidth: self.frame.width)
                    if self.imageUrlString == urlString {
                        self.newsThumb.image = imageToCache
                    }
                    if imageToCache != nil {
                        imageCache.setObject(imageToCache!, forKey: NSString(string: urlString))
                    }
                }
            }.resume()
        }
    }
}
