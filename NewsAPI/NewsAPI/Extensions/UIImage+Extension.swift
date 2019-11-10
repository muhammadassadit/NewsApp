//
//  UIImage+Extension.swift
//  NewsAPI
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    func saveImage(inDir:URL,name:String){
        let documentDirectoryPath = inDir
        //Change extension if you want to save as PNG.
        let imgPath = documentDirectoryPath.appendingPathComponent("/" + "\(name)").absoluteURL
        do {
            try self.jpegData(compressionQuality: 1.0)!.write(to: imgPath, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
    }
}

let imageCache = NSCache<NSString, UIImage>()
