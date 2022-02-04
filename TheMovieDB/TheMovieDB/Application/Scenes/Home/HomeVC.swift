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
    
    private var headerView: MovieHeaderView!
    lazy var headerHeight: CGFloat = {
        return view.frame.height + 200//520
    }()
    private let vwModel = HomeVwModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        //setupHeaderView()
        self.vwModel.loadMovieList()
        vwModel.refreshUI = { [weak self] in
            //self?.headerView.details = self?.vwModel.movieList.randomElement()?.content.randomElement()
            self?.tableVw.reloadData()
            self?.tableVw.toggleDisplayWithAnimation(true)
        }
    }
    
    func setupHeaderView() {
        /**
         no need to remove
         */
        headerView = MovieHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight/2))
        tableVw.tableHeaderView = nil
        tableVw.addSubview(headerView)
        tableVw.contentInset = UIEdgeInsets(top: headerHeight/2, left: 0, bottom: 0, right: 0)
        tableVw.contentOffset = CGPoint(x: 0, y: -headerHeight/2)
        headerView.infoHandler = { [weak self] (movieID, type)in
            guard let _ = self else { return }
            MovieListNavigator().showMovieDetailsVC(with: movieID, type: type)
        }
        
//        headerView = MovieHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight/2))
//        tableVw.estimatedRowHeight = UITableView.automaticDimension
//        tableVw.tableHeaderView = headerView
//        tableVw.tableHeaderView = nil
//        tableVw.contentInset = UIEdgeInsets(top: headerHeight/2, left: 0, bottom: 0, right: 0)
//        tableVw.addSubview(headerView)
        
        
        //updateHeaderLayout()
    }
    
    func updateHeaderLayout() {
        let offsetY = -(tableVw.contentOffset.y + tableVw.contentInset.top)
        if tableVw.contentOffset.y < -headerHeight {
            headerView.frame.origin.y = tableVw.contentOffset.y
            headerView.frame.size.height = -tableVw.contentOffset.y
            //headerView.imgVwBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
            headerView.infoBtnBottom.constant = offsetY >= 0 ? 0 : -offsetY / 5
        } else {
            //headerView.imgVwBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
            headerView.infoBtnBottom.constant = offsetY >= 0 ? 0 : -offsetY / 5
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
            cell.details = vwModel.movieList.randomElement()?.content.randomElement()
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
                MovieListNavigator().showMovieListVC(with: self.vwModel.movieList[indexPath.row - 1].content, type: self.vwModel.movieList[indexPath.row - 1].contentType)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //updateHeaderLayout()
        /*
        let yPos: CGFloat = -scrollView.contentOffset.y
        
        if yPos > 0 {
            var imgRect: CGRect? = headerView?.frame
            imgRect?.origin.y = scrollView.contentOffset.y
            imgRect?.size.height = headerHeight/2 + yPos  - headerHeight/2
            headerView?.frame = imgRect!
            self.tableVw.sectionHeaderHeight = (imgRect?.size.height)!
            
        }
 */
    }
}
