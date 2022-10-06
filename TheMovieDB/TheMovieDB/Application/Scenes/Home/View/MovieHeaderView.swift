//
//  MovieHeaderView.swift
//  TheMovieDB
//
//  Created by DS on 05/05/21.
//

import UIKit

class MovieHeaderView: UIView {
    
    @IBOutlet weak var contentView: UIView!
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
            //lblMovieName.text = details?.getMovieName() ?? ""
            lblGenres.text = SessionManager.shared.geners?.getlistOfName(ids: details?.genreIDS ?? []) ?? ""
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(MovieHeaderView.identifier, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    @IBAction func onTapInfoBtn(_ sender: UIButton) {
        infoHandler?(details?.id ?? 0, details?.mediaType ?? .movie)
    }
    
}
