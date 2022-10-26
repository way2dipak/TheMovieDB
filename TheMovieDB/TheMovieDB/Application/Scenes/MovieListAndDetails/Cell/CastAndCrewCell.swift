//
//  CastAndCrewCell.swift
//  TheMovieDB
//
//  Created by DS on 18/05/21.
//

import UIKit

class CastAndCrewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblActorName: UILabel! {
        didSet {
            lblActorName.font = AppFonts.medium(size: 12)
        }
    }
    @IBOutlet weak var lblCharacterName: UILabel! {
        didSet {
            lblCharacterName.font = AppFonts.regular(size: 9)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
