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
            tableVw.toggleDisplayWithAnimation(false)
        }
    }
    lazy var headerHeight: CGFloat = {
        return view.frame.height + 200
    }()
    private let vwModel = HomeVwModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        self.vwModel.loadMovieList()
        vwModel.refreshUI = { [weak self] in
            self?.tableVw.reloadData()
            self?.tableVw.toggleDisplayWithAnimation(true)
        }
    }
    
    func registerNIB() {
        tableVw.register(MovieHeaderCell.nib, forCellReuseIdentifier: MovieHeaderCell.identifier)
        tableVw.register(MovieCarouselCell.nib, forCellReuseIdentifier: MovieCarouselCell.identifier)
    }
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vwModel.movieList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieHeaderCell.identifier) as! MovieHeaderCell
            cell.details = vwModel.getRandomMovie()
            cell.infoHandler = { [weak self] (movieID, type)in
                guard let _ = self else { return }
                MovieListNavigator().showMovieDetailsVC(with: movieID, type: type)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCarouselCell.identifier) as! MovieCarouselCell
            cell.details = vwModel.movieList[indexPath.row - 1]
            cell.arrowHandler = { [weak self] in
                guard let self = self else { return }
                MovieListNavigator().showMovieListVC(with: self.vwModel.movieList[indexPath.row - 1].sectionData ?? [], type: self.vwModel.movieList[indexPath.row - 1].contentType, sectionName: self.vwModel.movieList[indexPath.row - 1].sectionTitle ?? "")
            }
            cell.selectedContentHandler = { [weak self] movieId, type in
                guard let _ = self else { return }
                MovieListNavigator().showMovieDetailsVC(with: movieId, type: type)
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
