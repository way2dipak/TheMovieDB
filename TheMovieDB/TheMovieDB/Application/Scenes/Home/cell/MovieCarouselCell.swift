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
    var genresHandler: ((Int, String) -> ())?
    
    var details: HomeList? {
        didSet {
            setupSkeleton()
            lblTitle.text = details?.sectionTitle ?? ""
            lblTitle.font = AppFonts.bold(size: 16)
            switch details?.contentType {
            case .exploreByGenres:
                btnArrow.isHidden = true
            default:
                btnArrow.isHidden = false
            }
            self.colVw.reloadData()
        }
    }
    
    func setupSkeleton() {
        //        if details?.sectionTitle ?? "" == "Explore By Genres" {
        //            colVwHeightConstraint.constant = 50//resized(size: CGSize(width: 130, height: 50), basedOn: .height).height
        //        } else {
        //            colVwHeightConstraint.constant = resized(size: CGSize(width: 100, height: 150), basedOn: .height).height
        //        }
        if details != nil {
            switch details!.contentType {
            case .exploreByGenres:
                colVwHeightConstraint.constant = 50
            case .castAndCrew:
                colVwHeightConstraint.constant = resized(size: CGSize(width: 100,
                                                                      height: 150),
                                                         basedOn: .height).height
            case .trailers:
                colVwHeightConstraint.constant = resized(size: CGSize(width: 200,
                                                                      height: 113),
                                                         basedOn: .height).height
            default:
                colVwHeightConstraint.constant = resized(size: CGSize(width: 100,
                                                                      height: 150),
                                                         basedOn: .height).height
            }
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
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch details?.contentType {
        case .exploreByGenres:
            let cell = colVw.dequeueReusableCell(withReuseIdentifier: GenresCell.identifier,
                                                 for: indexPath) as! GenresCell
            if details != nil {
                let itemDetails = details?.sectionData?[indexPath.row]
                cell.lblGenres.text = itemDetails?.name ?? ""
                //cell.imgVwBackdrop.loadImageWithUrl(with: itemDetails?.backdropPath ?? "", placeholderImage: #imageLiteral(resourceName: "posterPlaceholder"), type: .genres, completed: nil)
                cell.imgVwBackdrop.backgroundColor = AppColors.getColorFor(genres: itemDetails?.name ?? "")
                cell.startAnimation(false)
            } else {
                cell.startAnimation(true)
            }
            return cell
        case .castAndCrew:
            btnArrow.isHidden = true
            let cell = colVw.dequeueReusableCell(withReuseIdentifier: CastAndCrewCell.identifier,
                                                 for: indexPath) as! CastAndCrewCell
            let itemDetails = details?.sectionData?[indexPath.row]
            cell.lblActorName.text = itemDetails?.name ?? ""
            cell.lblCharacterName.text = itemDetails?.character ?? ""
            cell.imgVw.loadImageWithUrl(with: itemDetails?.profilePath ?? "", placeholderImage: #imageLiteral(resourceName: "posterPlaceholder"), completed: nil)
            return cell
        case .trailers:
            btnArrow.isHidden = true
            let cell = colVw.dequeueReusableCell(withReuseIdentifier: MovieTrailersCell.identifier,
                                                 for: indexPath) as! MovieTrailersCell
            let itemDetails = details?.sectionData?[indexPath.row]
            cell.imgVw.loadImageWithUrl(with: itemDetails?.key ?? "", placeholderImage: #imageLiteral(resourceName: "posterPlaceholder") , type: .youtube, completed: nil)
            return cell
        default:
            btnArrow.isHidden = false
            let cell = colVw.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.identifier,
                                                 for: indexPath) as! MoviePosterCell
            if details != nil {
                let itemDetails = details?.sectionData?[indexPath.row]
                cell.imgVw.loadImageWithUrl(with: itemDetails?.posterPath ?? "",
                                            placeholderImage: #imageLiteral(resourceName: "posterPlaceholder"),
                                            quality: .standard,
                                            completed: nil)
                cell.startAnimation(false)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let item = details {
            switch item.contentType {
            case .exploreByGenres:
                genresHandler?(details?.sectionData?[indexPath.row].id ?? 0, details?.sectionData?[indexPath.row].name ?? "")
            case .castAndCrew:
                return
            case .trailers:
                trailerContentHandler?(details?.sectionData?[indexPath.row].key ?? "")
            default:
                selectedContentHandler?(details?.sectionData?[indexPath.row].id ?? 0,
                                        details?.sectionData?[indexPath.row].mediaType ?? .movie)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if details == nil {
            return resized(size: CGSize(width: 100, height: 150), basedOn: .height)
        } else {
            switch details!.contentType {
            case .exploreByGenres:
                return CGSize(width: 120, height: 50)
            case .castAndCrew:
                return resized(size: CGSize(width: 100, height: 150), basedOn: .height)
            case .trailers:
                return resized(size: CGSize(width: 200, height: 113), basedOn: .height)
            default:
                return resized(size: CGSize(width: 100, height: 150), basedOn: .height)
            }
        }
    }
}
