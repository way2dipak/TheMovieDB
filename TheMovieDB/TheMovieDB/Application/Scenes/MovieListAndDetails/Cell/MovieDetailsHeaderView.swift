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
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTagLine: UILabel!
    @IBOutlet weak var lblRatings: UILabel!
    @IBOutlet weak var lblVotes: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var vwStar: StarRatingView! {
        didSet {
            //vwStar.transform = CGAffineTransform.init(scaleX: 5.3, y: 5.3)
        }
    }
    //@IBOutlet weak var lblGenres: UILabel!
    
    var details: MovieDetailsResponse? {
        didSet {
            imgVwCover.loadImageWithUrl(with: details?.backdropPath ?? details?.posterPath ?? "", placeholderImage: nil, completed: nil)
            lblTitle.text = details?.title ?? ""
            lblTagLine.text = details?.tagline ?? ""
            lblTagLine.setLineHeight(lineHeight: 5)
            let ratings = ((details?.voteAverage ?? 0.0) / 2)
            lblRatings.text = String(format: "%.1f", ratings)
            lblVotes.text = "\(details?.voteCount ?? 0) Votes"
            lblDuration.text = (details?.runtime ?? 0).minutesToHoursAndMinutes()
            vwStar.rating = Float((details?.voteAverage ?? 0.0) / 2)
            lblDate.text = details?.releaseDate?.formattedDate ?? ""
            
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
       // colvw.register(GenresCell.nib, forCellWithReuseIdentifier: GenresCell.identifier)
    }
}

/*
extension MovieDetailsHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return details?.genres?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenresCell.identifier, for: indexPath) as! GenresCell
        cell.lblName.text = details?.genres?[indexPath.row].name?.uppercased() ?? ""
        return cell
    }
    
}
*/
