//
//  MovieDetailsHeaderCell.swift
//  TheMovieDB
//
//  Created by DS on 22/07/21.
//

import UIKit

class MovieDetailsHeaderCell: UITableViewCell {
    
    @IBOutlet weak var imgVwBackdrop: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTagLine: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblRatings: UILabel!
    @IBOutlet weak var lblVotes: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var vwStar: StarRatingView! {
        didSet {
            //vwStar.transform = CGAffineTransform.init(scaleX: 5.3, y: 5.3)
        }
    }
    
    var details: MovieResultList? {
        didSet {
            imgVwBackdrop.loadImageWithUrl(with: details?.backdropPath ?? "", placeholderImage: nil, quality: .hd, completed: nil)
            lblTitle.text = details?.title ?? ""
            lblTagLine.text = details?.tagline ?? ""
            lblOverview.text = details?.overview ?? ""
            lblTagLine.setLineHeight(lineHeight: 5)
            lblOverview.setLineHeight(lineHeight: 5)
            let ratings = ((details?.voteAverage ?? 0.0) / 2)
            lblRatings.text = String(format: "%.1f", ratings)
            lblVotes.text = "\(details?.voteCount ?? 0) Votes"
            lblDuration.text = (details?.runtime ?? 0).minutesToHoursAndMinutes()
            vwStar.rating = Float((details?.voteAverage ?? 0.0) / 2)
            lblDate.text = details?.releaseDate?.formattedDate ?? ""
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
