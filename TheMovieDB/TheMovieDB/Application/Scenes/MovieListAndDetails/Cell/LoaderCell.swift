//
//  LoaderCell.swift
//  TheMovieDB
//
//  Created by DS on 15/05/21.
//

import UIKit

class LoaderCell: UICollectionViewCell {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func displaySpinner(_ toggle: Bool) {
        if toggle {
            spinner.isHidden = false
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
            spinner.isHidden = false
        }
    }
    
}
