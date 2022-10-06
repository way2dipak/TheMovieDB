//
//  MovieCarouselCell.swift
//  TheMovieDB
//
//  Created by DS on 11/05/21.
//

import UIKit
import TheMovieDBNetwork

class MovieCarouselCell: UITableViewCell {
    @IBOutlet weak var imgVwbackground: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var colVwHeightConstraint: NSLayoutConstraint!
    
    var arrowHandler: (() -> ())?
    var selectedContentHandler: ((Int, MediaType) -> ())?
    var trailerContentHandler: ((String) -> ())?
    
    var details: HomeList? {
        didSet {
            lblTitle.text = details?.sectionTitle ?? ""
            btnArrow.isHidden = false
            switch details?.contentType {
            case .exploreByGenres:
                btnArrow.isHidden = true
                colVwHeightConstraint.constant = 80
            case .castAndCrew:
                colVwHeightConstraint.constant = 213
            case .trailers:
                colVwHeightConstraint.constant = 121
            default:
                colVwHeightConstraint.constant = 198
            }
            colVw.layoutIfNeeded()
            colVw.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startAnimation(true)
        colVw.register(MoviePosterCell.nib, forCellWithReuseIdentifier: MoviePosterCell.identifier)
        colVw.register(MovieTrailersCell.nib, forCellWithReuseIdentifier: MovieTrailersCell.identifier)
        colVw.register(CastAndCrewCell.nib, forCellWithReuseIdentifier: CastAndCrewCell.identifier)
        colVw.register(GenresCell.nib, forCellWithReuseIdentifier: GenresCell.identifier)
    }
    
    func startAnimation(_ toggle: Bool) {
        if toggle {
            lblTitle.showAnimatedSkeleton()
            btnArrow.showAnimatedSkeleton()
            colVw.showAnimatedSkeleton()
        } else {
            lblTitle.hideSkeleton()
            btnArrow.hideSkeleton()
            colVw.hideSkeleton()
        }
    }
    
    @IBAction func onTapArrowBtn(_ sender: UIButton) {
        arrowHandler?()
    }
    
}

extension MovieCarouselCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if details == nil { return 10 }
        return details!.sectionData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if details?.contentType == .castAndCrew {
            btnArrow.isHidden = true
            let cell = colVw.dequeueReusableCell(withReuseIdentifier: CastAndCrewCell.identifier, for: indexPath) as! CastAndCrewCell
            let itemDetails = details?.sectionData?[indexPath.row]
            cell.lblActorName.text = itemDetails?.name ?? ""
            cell.lblCharacterName.text = itemDetails?.character ?? ""
            cell.imgVw.loadImageWithUrl(with: itemDetails?.profilePath ?? "", placeholderImage: #imageLiteral(resourceName: "posterPlaceholder"), completed: nil)
            return cell
        } else if details?.contentType == .trailers {
            btnArrow.isHidden = true
            self.colVwHeightConstraint.constant = 131
            let cell = colVw.dequeueReusableCell(withReuseIdentifier: MovieTrailersCell.identifier, for: indexPath) as! MovieTrailersCell
            let itemDetails = details?.sectionData?[indexPath.row]
            cell.imgVw.loadImageWithUrl(with: itemDetails?.key ?? "", placeholderImage: #imageLiteral(resourceName: "posterPlaceholder") , type: .youtube, completed: nil)
            return cell
        } else if details?.contentType == .exploreByGenres {
            let cell = colVw.dequeueReusableCell(withReuseIdentifier: GenresCell.identifier, for: indexPath) as! GenresCell
            if details != nil {
                let itemDetails = details?.sectionData?[indexPath.row]
                cell.lblGenres.text = itemDetails?.name ?? ""
                cell.imgVwBackdrop.loadImageWithUrl(with: itemDetails?.backdropPath ?? "", placeholderImage: #imageLiteral(resourceName: "posterPlaceholder"), type: .genres, completed: nil)
                cell.startAnimation(false)
            } else {
                cell.startAnimation(true)
            }
            return cell
        } else {
            btnArrow.isHidden = false
            let cell = colVw.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.identifier, for: indexPath) as! MoviePosterCell
            if details != nil {
                let itemDetails = details?.sectionData?[indexPath.row]
                cell.imgVw.loadImageWithUrl(with: itemDetails?.posterPath ?? "", placeholderImage: #imageLiteral(resourceName: "posterPlaceholder"), quality: .standard, completed: nil)
                cell.startAnimation(false)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = details {
            if item.contentType == .castAndCrew {
                return
            } else if item.contentType == .trailers {
                trailerContentHandler?(details?.sectionData?[indexPath.row].key ?? "")
            } else {
                selectedContentHandler?(details?.sectionData?[indexPath.row].id ?? 0, details?.sectionData?[indexPath.row].mediaType ?? .movie)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if details == nil {
            return CGSize(width: 132, height: 198)
        }
        if details!.contentType == .castAndCrew {
            //return CGSize(width: 188, height: 188)
            return CGSize(width: 138, height: 213)
        } else if details!.contentType == .trailers {
            return CGSize(width: 232, height: 121)//378.5, 213
        } else if details!.contentType == .exploreByGenres {
            return CGSize(width: 180, height: 80)
        } else {
           return CGSize(width: 132, height: 198)//CGSize(width: 120, height: 181)
        }
    }
}
