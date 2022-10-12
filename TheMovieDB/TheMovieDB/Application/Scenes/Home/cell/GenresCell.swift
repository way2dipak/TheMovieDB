//
//  GenresCell.swift
//  TheMovieDB
//
//  Created by Dipak Singh on 15/06/22.
//

import UIKit

class GenresCell: UICollectionViewCell {
    
    @IBOutlet weak var lblGenres: UILabel! {
        didSet {
            lblGenres.font = AppFonts.bold(size: 12)
        }
    }
    @IBOutlet weak var imgVwBackdrop: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func startAnimation(_ toggle: Bool) {
        if toggle {
            lblGenres.showAnimatedSkeleton()
            imgVwBackdrop.showAnimatedSkeleton()
        } else {
            lblGenres.hideSkeleton()
            imgVwBackdrop.hideSkeleton()
        }
    }

}
