//
//  MovieHeaderIpadCell.swift
//  TheMovieDB
//
//  Created by Dipak Singh on 18/10/22.
//

import UIKit

class MovieHeaderIpadCell: UITableViewCell {
    
    @IBOutlet weak var imgVwBackdrop: UIImageView!
    @IBOutlet weak var lblMovieName: UILabel! {
        didSet {
            lblMovieName.font = AppFonts.black(size: 25)
        }
    }
    @IBOutlet weak var lblDescription: UILabel! {
        didSet {
            lblDescription.font = AppFonts.light(size: 15)
        }
    }
    @IBOutlet weak var lblGenres: UILabel! {
        didSet {
            lblGenres.font = AppFonts.regular(size: 15)
        }
    }
    
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
            imgVwBackdrop.loadImageWithUrl(with: details?.posterPath,
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
            lblMovieName.showAnimatedSkeleton()
            lblDescription.showAnimatedSkeleton()
            lblGenres.showAnimatedSkeleton()
            infoBtnBottom.showAnimatedSkeleton()
        } else {
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
