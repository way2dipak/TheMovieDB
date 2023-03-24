//
//  MovieHeaderCell.swift
//  TheMovieDB
//
//  Created by DS on 22/07/21.
//

import UIKit
import SkeletonView

class MovieHeaderCell: UITableViewCell {
    
    @IBOutlet weak var imgVwPoster: UIImageView!
    @IBOutlet weak var lblMovieName: UILabel! {
        didSet {
            lblMovieName.font = AppFonts.black(size: 29)
        }
    }
    @IBOutlet weak var lblDescription: UILabel! {
        didSet {
            lblDescription.font = AppFonts.light(size: 12)
        }
    }
    @IBOutlet weak var lblGenres: UILabel! {
        didSet {
            lblGenres.font = AppFonts.regular(size: 12)
        }
    }
    
    @IBOutlet weak var containerVwHeight: NSLayoutConstraint!
    @IBOutlet weak var imgVwHeight: NSLayoutConstraint!
    @IBOutlet weak var imgVwBottom: NSLayoutConstraint!
    @IBOutlet weak var imgVwTop: NSLayoutConstraint!
    @IBOutlet weak var infoBtnBottom: UIButton! {
        didSet {
            infoBtnBottom.setTitle("More", for: .normal)
            infoBtnBottom.titleLabel?.font = AppFonts.medium(size: 12)
        }
    }
    @IBOutlet weak var stackVw: UIStackView!
    
    var infoHandler: ((Int, MediaType) -> ())?
    
    var details: MovieResultList? {
        didSet {
            imgVwPoster.loadImageWithUrl(with: isIphone ? details?.posterPath : details?.backdropPath,
                                         placeholderImage: nil,
                                         quality: .hd,
                                         completed: nil)
            lblMovieName.text = details?.getMovieName() ?? ""
            lblMovieName.setLineHeight(lineHeight: 0.8)
            lblDescription.text = details?.overview ?? ""
            lblDescription.setLineHeight(lineHeight: 5)
            lblGenres.text = SessionManager.shared.geners?.getlistOfName(ids: details?.genreIDS ?? [])
        }
    }
    
    func startAnimation(_ toggle: Bool) {
        if toggle {
            imgVwPoster.showAnimatedSkeleton()
            lblMovieName.showAnimatedSkeleton()
            lblDescription.showAnimatedSkeleton()
            lblGenres.showAnimatedSkeleton()
            infoBtnBottom.showAnimatedSkeleton()
        } else {
            imgVwPoster.hideSkeleton()
            lblMovieName.hideSkeleton()
            lblDescription.hideSkeleton()
            lblGenres.hideSkeleton()
            infoBtnBottom.hideSkeleton()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startAnimation(true)
    }
    
    @IBAction func onTapInfoBtn(_ sender: UIButton) {
        infoHandler?(details?.id ?? 0, details?.mediaType ?? .movie)
    }
    
}
