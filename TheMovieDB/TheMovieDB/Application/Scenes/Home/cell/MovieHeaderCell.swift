//
//  MovieHeaderCell.swift
//  TheMovieDB
//
//  Created by DS on 22/07/21.
//

import UIKit

class MovieHeaderCell: UITableViewCell {
    
    @IBOutlet weak var imgVwPoster: UIImageView!
    @IBOutlet weak var lblMovieName: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    
    @IBOutlet weak var containerVwHeight: NSLayoutConstraint!
    @IBOutlet weak var imgVwHeight: NSLayoutConstraint!
    @IBOutlet weak var imgVwBottom: NSLayoutConstraint!
    @IBOutlet weak var imgVwTop: NSLayoutConstraint!
    @IBOutlet weak var infoBtnBottom: NSLayoutConstraint!
    
    var infoHandler: ((Int, MediaType) -> ())?
    
    var details: MovieResultList? {
        didSet {
            imgVwPoster.loadImageWithUrl(with: details?.posterPath, placeholderImage: nil, completed: nil)
            lblMovieName.text = details?.getMovieName() ?? ""
            lblGenres.text = SessionManager.shared.geners.getlistOfName(ids: details?.genreIDS ?? [])
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onTapInfoBtn(_ sender: UIButton) {
        infoHandler?(details?.id ?? 0, details?.mediaType ?? .movie)
    }
    
}
