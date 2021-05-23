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
    
    var arrowHandler: (() -> ())?
    var selectedContentHandler: ((Int, MediaType) -> ())?
    
    var details: HomeModel? {
        didSet {
            lblTitle.text = details?.sectionName ?? ""
            colVw.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        colVw.register(MoviePosterCell.nib, forCellWithReuseIdentifier: MoviePosterCell.identifier)
        colVw.register(MovieTrailersCell.nib, forCellWithReuseIdentifier: MovieTrailersCell.identifier)
        colVw.register(CastAndCrewCell.nib, forCellWithReuseIdentifier: CastAndCrewCell.identifier)
    }
    
    @IBAction func onTapArrowBtn(_ sender: UIButton) {
        arrowHandler?()
    }
    
}

extension MovieCarouselCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if details == nil { return 0 }
        if details!.contentType == .castAndCrew {
            return details!.castAndCrewContent.count
        } else if details!.contentType == .trailers {
            return details!.trailersContent.count
        } else {
            return details?.content.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if details == nil { return UICollectionViewCell() }
        if details!.contentType == .castAndCrew {
            btnArrow.isHidden = true
            let cell = colVw.dequeueReusableCell(withReuseIdentifier: CastAndCrewCell.identifier, for: indexPath) as! CastAndCrewCell
            //let cell = colVw.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.identifier, for: indexPath) as! MoviePosterCell
            cell.lblActorName.text = details?.castAndCrewContent[indexPath.row].name ?? ""
            cell.lblCharacterName.text = details?.castAndCrewContent[indexPath.row].character ?? ""
            cell.imgVw.loadImageWithUrl(with: details?.castAndCrewContent[indexPath.row].profilePath ?? "", placeholderImage: #imageLiteral(resourceName: "posterPlaceholder") , completed: nil)
            return cell
        } else if details!.contentType == .trailers {
            btnArrow.isHidden = true
            let cell = colVw.dequeueReusableCell(withReuseIdentifier: MovieTrailersCell.identifier, for: indexPath) as! MovieTrailersCell
            cell.imgVw.loadImageWithUrl(with: details?.trailersContent[indexPath.row].key ?? "", placeholderImage: #imageLiteral(resourceName: "posterPlaceholder") , type: .youtube, completed: nil)
            return cell
        } else {
            btnArrow.isHidden = false
            let cell = colVw.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.identifier, for: indexPath) as! MoviePosterCell
            cell.imgVw.loadImageWithUrl(with: details?.content[indexPath.row].posterPath ?? "", placeholderImage: #imageLiteral(resourceName: "posterPlaceholder") , completed: nil)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = details, item.contentType == .castAndCrew || item.contentType == .trailers { return }
        selectedContentHandler?(details?.content[indexPath.row].id ?? 0, details?.content[indexPath.row].mediaType ?? .movie)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if details == nil { return .zero }
        if details!.contentType == .castAndCrew {
            //return CGSize(width: 188, height: 188)
            return CGSize(width: 138, height: 213)
        } else if details!.contentType == .trailers {
            return CGSize(width: 285, height: 213)
        } else {
            return CGSize(width: 138, height: 213)
        }
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = colVw.cellForItem(at: indexPath) as? MoviePosterCell else { return }
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let _ = self else { return }
            cell.imgVw.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { [weak self] (_) in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.1) { [weak self] in
                guard let _ = self else { return }
                cell.imgVw.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }

    }
 */
    
}
