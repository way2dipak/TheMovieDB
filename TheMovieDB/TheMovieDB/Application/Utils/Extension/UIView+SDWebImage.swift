//
//  UIView+SDWebImage.swift
//  TheMovieDB
//
//  Created by DS on 02/05/21.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    
    func loadImageWithUrl(with: URL?,
                          placeholderImage: UIImage,
                          completed: SDExternalCompletionBlock?) {
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: with, placeholderImage: placeholderImage, options: [], completed: completed)
    }
    
    func normalLoad(url:String?, placeholderImage: UIImage? = nil) {
        if let url = URL.init(string: url ?? "") {
            self.sd_setImage(with: url, placeholderImage: placeholderImage, options:.queryMemoryData, completed: { (image, error, cacheType, url) in
            })
        }else {
            if placeholderImage != nil {
                self.image = placeholderImage
            }
        }
    }
}

extension UIButton {
    func loadImageWithUrl(with: URL?,
                          placeholderImage: UIImage,
                          completed: SDExternalCompletionBlock?) {
        self.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.sd_setImage(with: with, for: .normal, placeholderImage: placeholderImage, options: [], completed: completed)
    }
    
    
}
