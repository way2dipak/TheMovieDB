//
//  HomeVC.swift
//  TheMovieDB
//
//  Created by DS on 05/05/21.
//

import UIKit

class HomeVC: BaseVC {
    
    @IBOutlet weak var tableVw: UITableView! {
        didSet {
            //tableVw.toggleDisplayWithAnimation(false)
        }
    }
    private let vwModel = HomeVwModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        vwModel.loadMovieList()
        vwModel.refreshUI = { [weak self] in
            self?.tableVw.reloadData()
            //self?.tableVw.toggleDisplayWithAnimation(true)
        }
    }
    
    func registerNIB() {
        if isIphone {
            tableVw.register(MovieHeaderCell.nib, forCellReuseIdentifier: MovieHeaderCell.identifier)
        } else {
            tableVw.register(MovieHeaderIpadCell.nib, forCellReuseIdentifier: MovieHeaderIpadCell.identifier)
        }
        tableVw.register(MovieCarouselCell.nib, forCellReuseIdentifier: MovieCarouselCell.identifier)
    }
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vwModel.movieList.count != 0 {
            return vwModel.movieList.count + 1
        } else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if isIphone {
                let cell = tableView.dequeueReusableCell(withIdentifier: MovieHeaderCell.identifier) as! MovieHeaderCell
                if vwModel.movieList.count != 0 {
                    cell.startAnimation(false)
                    cell.details = vwModel.getRandomMovie()
                }
                cell.infoHandler = { [weak self] (movieID, type)in
                    guard let _ = self else { return }
                    MovieListNavigator().showMovieDetailsVC(with: movieID, type: type)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: MovieHeaderIpadCell.identifier) as! MovieHeaderIpadCell
                if vwModel.movieList.count != 0 {
                    cell.startAnimation(false)
                    cell.details = vwModel.getRandomMovie()
                }
                cell.infoHandler = { [weak self] (movieID, type)in
                    guard let _ = self else { return }
                    MovieListNavigator().showMovieDetailsVC(with: movieID, type: type)
                }
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCarouselCell.identifier) as! MovieCarouselCell
            if vwModel.movieList.count != 0 {
                cell.details = vwModel.movieList[indexPath.row - 1]
                cell.startAnimation(false)
            } else {
                if indexPath.row == 1 {
                    cell.colVwHeightConstraint.constant = isIphone ? 80 : 80
                } else {
                    //cell.colVwHeightConstraint.constant = 198
                }
            }
            cell.arrowHandler = { [weak self] in
                guard let self = self else { return }
                MovieListNavigator().showMovieListVC(with: self.vwModel.movieList[indexPath.row - 1].sectionData ?? [], type: self.vwModel.movieList[indexPath.row - 1].contentType, sectionName: self.vwModel.movieList[indexPath.row - 1].sectionTitle ?? "")
            }
            cell.selectedContentHandler = { [weak self] movieId, type in
                guard let _ = self else { return }
                MovieListNavigator().showMovieDetailsVC(with: movieId, type: type)
            }
            
            cell.genresHandler = { [weak self] genresId, sectionName in
                guard let _ = self else { return }
                MovieListNavigator().showMovieListVC(with: [], type: .exploreByGenres, sectionName: sectionName, genreId: genresId)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return (self.view.frame.height/2) + 150
        }
        return UITableView.automaticDimension
    }
}
