//
//  ImageViewExtension.swift
//  Muknow
//
//  Created by Apple on 25/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

    func loadImageUsingCacheWithURLString(_ URLString: String, placeHolder: UIImage?,loader:UIActivityIndicatorView?) {

        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            if loader != nil {
                loader!.isHidden = true
                loader!.stopAnimating()
            }
            return
        }

        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    DispatchQueue.main.async { [weak self] in
                        self?.image = placeHolder
                        if loader != nil {
                            loader!.isHidden = true
                            loader!.stopAnimating()
                        }
                        
                    }
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self?.image = downloadedImage
                            if loader != nil {
                                loader!.isHidden = true
                                loader!.stopAnimating()
                            }
                            
                        }else{
                            self?.image = placeHolder
                            imageCache.setObject(placeHolder!, forKey: NSString(string: URLString))
                            if loader != nil {
                                loader!.isHidden = true
                                loader!.stopAnimating()
                            }
                            
                        }
                    }
                }
            }).resume()
        }else{
            
        }
    }
}
