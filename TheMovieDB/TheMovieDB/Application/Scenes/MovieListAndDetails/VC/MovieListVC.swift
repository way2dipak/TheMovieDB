//
//  MovieListVC.swift
//  TheMovieDB
//
//  Created by DS on 15/05/21.
//

import UIKit

class MovieListVC: BaseVC {
    
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    var vwModel = MovieListVwModel() {
        didSet {
            colVw.reloadData()
        }
    }
    
    var type: SectionType = .exploreByGenres
    var sectionName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        lblTitle.text = sectionName
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.identifier, for: indexPath) as! MoviePosterCell
            let details = vwModel.movieList[indexPath.row]
            cell.imgVw.loadImageWithUrl(with: details.posterPath, placeholderImage: #imageLiteral(resourceName: "posterPlaceholder"), completed: nil)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoaderCell.identifier, for: indexPath) as! LoaderCell
            cell.displaySpinner(true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.vwModel.fetchMoviesFor(type: self.sectionName.lowercased())
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let details = vwModel.movieList[indexPath.row]
        MovieListNavigator().showMovieDetailsVC(with: details.id ?? 0, type: details.mediaType ?? .movie)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width = (collectionView.bounds.width - 20) / 3
            return CGSize(width: width, height: width + 50)
        } else {
            return CGSize(width: collectionView.frame.width, height: 80)
        }
    }
}
