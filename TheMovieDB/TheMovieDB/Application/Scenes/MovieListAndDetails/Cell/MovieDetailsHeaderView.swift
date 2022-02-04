//
//  MovieDetailsHeaderView.swift
//  TheMovieDB
//
//  Created by DS on 16/05/21.
//

import UIKit

class MovieDetailsHeaderView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgVwCover: UIImageView!
    
    var details: MovieDetailsResponse? {
        didSet {
            imgVwCover.loadImageWithUrl(with: details?.backdropPath ?? details?.posterPath ?? "", placeholderImage: nil, quality: .standard, completed: nil)
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
        Bundle.main.loadNibNamed(MovieDetailsHeaderView.identifier, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
