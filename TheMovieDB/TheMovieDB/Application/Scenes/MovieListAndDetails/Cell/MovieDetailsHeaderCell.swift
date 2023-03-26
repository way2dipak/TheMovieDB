//
//  MovieDetailsHeaderCell.swift
//  TheMovieDB
//
//  Created by DS on 22/07/21.
//

import UIKit

class MovieDetailsHeaderCell: UITableViewCell {
    
    @IBOutlet weak var imgVwBackdrop: UIImageView!
    @IBOutlet weak var lblTitle: UILabel! {
        didSet {
            lblTitle.font = AppFonts.bold(size: 24)
        }
    }
    @IBOutlet weak var lblTagLine: UILabel! {
        didSet {
            lblTagLine.font = AppFonts.light(size: 12)
        }
    }
    @IBOutlet weak var lblOverview: UILabel! {
        didSet {
            lblOverview.font = AppFonts.light(size: 12)
        }
    }
    @IBOutlet weak var lblRatings: UILabel! {
        didSet {
            lblRatings.font = AppFonts.medium(size: 44)
        }
    }
    @IBOutlet weak var lblVotes: UILabel! {
        didSet {
            lblVotes.font = AppFonts.medium(size: 12)
        }
    }
    @IBOutlet weak var lblDuration: UILabel! {
        didSet {
            lblDuration.font = AppFonts.regular(size: 12)
        }
    }
    @IBOutlet weak var lblDate: UILabel! {
        didSet {
            lblDate.font = AppFonts.bold(size: 12)
        }
    }
    @IBOutlet weak var vwStar: UIView!
    @IBOutlet weak var btnPlay: LoadingButton!
    @IBOutlet weak var imgVwClock: UIImageView!
    @IBOutlet weak var vwVotes: UIView! {
        didSet {
            vwVotes.isHidden = true
        }
    }
    @IBOutlet weak var vwYear: UIView!
    
    var playhandler: (() -> ())?
    
    var details: MovieResultList? {
        didSet {
            imgVwBackdrop.loadImageWithUrl(with: details?.backdropPath ?? "" != "" ? details?.backdropPath ?? "" : details?.posterPath ?? "", placeholderImage: nil, quality: .hd, completed: nil)
            lblTitle.text = details?.title ?? ""
            lblTagLine.text = details?.tagline ?? ""
            lblOverview.text = details?.overview ?? ""
            lblTagLine.setLineHeight(lineHeight: 5)
            lblOverview.setLineHeight(lineHeight: 5)
            let ratings = ((details?.voteAverage ?? 0.0) / 2)
            lblRatings.text = String(format: "%.1f", ratings)
            lblVotes.text = "\(details?.voteCount ?? 0) Votes"
            lblDuration.text = (details?.runtime ?? 0).minutesToHoursAndMinutes()
            let starView = StarRatingView(frame: vwStar.bounds,totalStarCount: 5, currentStarCount: CGFloat((details?.voteAverage ?? 0.0) / 2), starSpace: 10)
            vwStar.addSubview(starView)
            lblDate.text = details?.releaseDate?.formattedDate ?? ""
            vwVotes.isHidden = false
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        startAnimation(true)
    }
    
    func startAnimation(_ toggle: Bool) {
        if toggle {
            [lblTitle, lblTagLine, lblOverview, lblRatings, lblVotes, lblDuration].forEach({ $0?.showAnimatedSkeleton() })
            [imgVwBackdrop, imgVwClock, vwVotes, vwYear].forEach({ $0?.showAnimatedSkeleton() })
        } else {
            [lblTitle, lblTagLine, lblOverview, lblRatings, lblVotes, lblDuration].forEach({ $0?.hideSkeleton() })
            [imgVwBackdrop, imgVwClock, vwVotes, vwYear].forEach({ $0?.hideSkeleton() })
        }
    }

    @IBAction func onTapPlayBtn(_ sender: UIButton) {
        playhandler?()
    }
}
