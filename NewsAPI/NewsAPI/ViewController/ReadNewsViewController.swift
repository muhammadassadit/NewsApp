//
//  ReadNewsViewController.swift
//  NewsAPI
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//

import UIKit

class ReadNewsViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var label: UILabel!    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    
    var imageViewRealFrame: CGRect!
    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReadNews()
    }
    
    
    private func setupReadNews() {
        scrollView.delegate = self
        
        imageViewRealFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        imageView.frame = imageViewRealFrame
        
        loadDataInViews()
        
        label.translatesAutoresizingMaskIntoConstraints = true
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        label.layer.cornerRadius = 10
        
        contentTextView.translatesAutoresizingMaskIntoConstraints = true
        contentTextView.sizeToFit()
        contentTextView.isScrollEnabled = false
        contentTextView.layer.cornerRadius = 10
        resizeScrollView()
    }
    
    
    func loadDataInViews() {
        guard let data = viewModel.currentNewsData else { return }
        
        label.text = data.title
        self.title = data.title
        contentTextView.text = data.content
        
        contentTextView.text += "\n\nRead more: \(data.url!)"
        
        // indicator
        let indicator = UIActivityIndicatorView(frame: self.view.frame)
        indicator.backgroundColor = self.scrollView.backgroundColor
        indicator.style = .whiteLarge
        indicator.startAnimating()
        view.addSubview(indicator)
        
        if data.urlToImage != nil {
            let urlString = data.urlToImage!
            let url = URL(string: urlString)
            if url == nil { indicator.stopAnimating(); return}
            URLSession.shared.dataTask(with: url!) { (data, responder, error) in
                if error != nil {
                    print(error as Any)
                    return
                }
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    self.imageView.image = image
                    self.resizeImageView()
                    self.resizeScrollView()
                    indicator.stopAnimating()
                }
            }.resume()
        } else {
            indicator.stopAnimating()
        }
    }
    
    private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func resizeScrollView() {
        let selfWidth = self.view.frame.width
        let spaceHeight:CGFloat = 10.0
        
        // set position
        label.frame = CGRect(x: 5.0, y: imageView.frame.maxY + spaceHeight, width: selfWidth - 10, height: label.frame.height)
        contentTextView.frame = CGRect(x: 5.0, y: label.frame.maxY + spaceHeight, width: selfWidth - 10, height: contentTextView.frame.height)
        // set contentSize
        scrollView.contentSize = CGSize(width: selfWidth, height: contentTextView.frame.maxY)
    }
    
    private func resizeImageView() {
        var scale: CGFloat
        var newHeight: CGFloat
        var newWidth: CGFloat
        
        if imageView.image!.size.width > imageView.image!.size.height {
            scale = self.view.frame.width / imageView.image!.size.width
            newHeight = imageView.image!.size.height * scale
            newWidth = self.view.frame.width
        } else {
            scale = self.view.frame.height / imageView.image!.size.height
            newHeight = self.view.frame.height
            newWidth = imageView.image!.size.width * scale
            
            if newWidth > self.view.frame.width {
                scale = self.view.frame.width / newWidth
                newHeight = newHeight * scale
                newWidth = self.view.frame.width
            }
        }
        
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: newWidth, height: newHeight)
        imageViewRealFrame = imageView.frame
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if navigationController == nil { return }
        let offset = scrollView.contentOffset.y + navigationController!.navigationBar.frame.maxY
        
        if offset < 0 {
            let width = imageView.frame.width
            imageView.frame = CGRect(x: 0.0, y: imageViewRealFrame.minY + offset, width: width, height: imageViewRealFrame.height - offset)
        }
    }
}
