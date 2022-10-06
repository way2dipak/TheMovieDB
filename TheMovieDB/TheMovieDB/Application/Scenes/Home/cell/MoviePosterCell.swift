//
//  MoviePosterCell.swift
//  TheMovieDB
//
//  Created by DS on 11/05/21.
//

import UIKit

class MoviePosterCell: UICollectionViewCell {
    
    @IBOutlet weak var imgVw: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        startAnimation(true)
    }

    func startAnimation(_ toggle: Bool) {
        if toggle {
            imgVw.showAnimatedSkeleton()
        } else {
            imgVw.hideSkeleton()
        }
    }
    
}
