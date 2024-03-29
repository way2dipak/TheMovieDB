//
//  MovieListVC.swift
//  TheMovieDB
//
//  Created by DS on 15/05/21.
//

import UIKit

class MovieListVC: BaseVC {
    
    @IBOutlet weak var colVw: UICollectionView! {
        didSet {
            colVw.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        }
    }
    @IBOutlet weak var lblTitle: UILabel! {
        didSet {
            lblTitle.font = AppFonts.bold(size: 18)
        }
    }
    var vwModel = MovieListVwModel() {
        didSet {
            colVw.reloadData()
        }
    }
    
    var type: SectionType = .exploreByGenres
    var sectionName = ""
    var genresId = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        lblTitle.text = sectionName
        if type == .exploreByGenres {
            vwModel.currentPage = 1
            vwModel.fetchMoviesBasedOn(genres: genresId)
        }
        vwModel.refreshUI = { [weak self] in
            guard let self = self else { return }
            self.colVw.reloadData()
        }
    }
    
    func registerNIB() {
        colVw.register(MoviePosterCell.nib, forCellWithReuseIdentifier: MoviePosterCell.identifier)
        colVw.register(LoaderCell.nib, forCellWithReuseIdentifier: LoaderCell.identifier)
    }
    
    @IBAction func onTapBackBtn(_ sender: UIButton) {
        dismissVC()
    }
}

extension MovieListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return vwModel.getNumberOfSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vwModel.getNumberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.identifier,
                                                          for: indexPath) as! MoviePosterCell
            if vwModel.movieList.count != 0 {
                cell.hideSkeleton()
                let details = vwModel.movieList[indexPath.row]
                cell.imgVw.contentMode = .scaleAspectFill
                cell.imgVw.loadImageWithUrl(with: details.posterPath,
                                            placeholderImage: #imageLiteral(resourceName: "posterPlaceholder"),
                                            completed: nil)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoaderCell.identifier,
                                                          for: indexPath) as! LoaderCell
            cell.displaySpinner(true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if self.type == .exploreByGenres {
                    self.vwModel.fetchMoviesBasedOn(genres: self.genresId)
                } else {
                    self.vwModel.fetchMoviesFor(type: self.sectionName.lowercased())
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let details = vwModel.movieList[indexPath.row]
        MovieListNavigator().showMovieDetailsVC(with: details.id ?? 0,
                                                type: details.mediaType ?? .movie)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let aspectRatio: CGFloat = 3/2  // A movie poster has 3:2 dimension, so aspect ratio is 1.5
            let numberOfItemsInRow: CGFloat = isIphone ? 3 : 8
            
            let collectionViewCellSizeWidth: CGFloat = ((collectionView.frame.size.width - (isIphone ? 20 : 60)) / numberOfItemsInRow)
            let collectionViewCellSizeHeight: CGFloat = collectionViewCellSizeWidth * aspectRatio
            
            return CGSize(
                width: collectionViewCellSizeWidth,
                height: collectionViewCellSizeHeight
            )
        } else {
            return CGSize(width: collectionView.frame.width, height: 80)
        }
    }
}
