//
//  MovieDetilsVC.swift
//  TheMovieDB
//
//  Created by DS on 16/05/21.
//

import UIKit

class MovieDetilsVC: BaseVC {
    
    @IBOutlet weak var tableVw: UITableView! {
        didSet {
            tableVw.toggleDisplayWithAnimation(false)
        }
    }
    
    @IBOutlet weak var vwPlayer: UIView!
    
    private var headerView: MovieDetailsHeaderView!
    
    lazy var headerHeight: CGFloat = {
        return view.frame.height//520
    }()
    
    var movieID = 0 /*{
        didSet {
            vwModel.getMovieDetails(by: movieID)
        }
    }*/
    
    private let vwModel = MovieDetailsVwModel()
    private weak var player: PlayerHandler?
    
    var playPauseHandler: ((Bool) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        setupHeaderView()
        //loadDetails()
    }
    
    func loadDetails(movieId: Int, type: MediaType) {
        vwModel.getMovieDetails(by: movieId, and: type)
        vwModel.refreshUI = { [weak self] in
            guard let self = self else { return }
            self.headerView.details = self.vwModel.movieDetails
            if self.vwModel.getVideoForHeader() != "" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.player = PlayerHandler(videoId: self.vwModel.getVideoForHeader(), parentView: self.headerView.imgVwCover, playerDelegate: self, showContentFill: true)
                }
            }
            self.tableVw.reloadData()
            self.tableVw.toggleDisplayWithAnimation(true)
        }
    }
    
    func registerNIB() {
        tableVw.register(MovieCarouselCell.nib, forCellReuseIdentifier: MovieCarouselCell.identifier)
        tableVw.register(StorylineCell.nib, forCellReuseIdentifier: StorylineCell.identifier)
    }
    
    @IBAction func onTapBackBtn(_ sender: UIButton) {
        player = nil
        dismissVC()
    }
    
    func setupHeaderView() {
        /**
         no need to remove
         */
        headerView = MovieDetailsHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight/2))
        tableVw.tableHeaderView = nil
        tableVw.estimatedSectionHeaderHeight = headerHeight/2
        tableVw.sectionHeaderHeight = UITableView.automaticDimension
        tableVw.addSubview(headerView)
        tableVw.contentInset = UIEdgeInsets(top: headerHeight/2, left: 0, bottom: 20, right: 0)
        tableVw.contentOffset = CGPoint(x: 0, y: -headerHeight/2)
        
//        headerView = MovieHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight/2))
//        tableVw.estimatedRowHeight = UITableView.automaticDimension
//        tableVw.tableHeaderView = headerView
//        tableVw.tableHeaderView = nil
//        tableVw.contentInset = UIEdgeInsets(top: headerHeight/2, left: 0, bottom: 0, right: 0)
//        tableVw.addSubview(headerView)
        
        
        //updateHeaderLayout()
    }
    
    deinit {
        print("Movie details vc deinited")
    }
    
}

extension MovieDetilsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return  1
        } else {
            return vwModel.movieList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: StorylineCell.identifier) as! StorylineCell
            cell.storyLine = vwModel.movieDetails?.overview ?? ""
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCarouselCell.identifier) as! MovieCarouselCell
            cell.details = vwModel.movieList[indexPath.row]
            
            cell.arrowHandler = { [weak self] in
                guard let self = self else { return }
                self.player = nil
                MovieListNavigator().showMovieListVC(with: self.vwModel.movieList[indexPath.row].content, type: self.vwModel.movieList[indexPath.row].contentType)
            }
            
            cell.selectedContentHandler = { [weak self] movieId, type in
                guard let self = self else { return }
                self.player = nil
                MovieListNavigator().showMovieDetailsVC(with: movieId, type: type)
            }
            
            cell.trailerContentHandler = { [weak self] videoId in
                guard let self = self else { return }
                self.player = nil
                MovieListNavigator().showVideoPlayerVC(with: self.vwModel.movieDetails, videoID: videoId, videoList: self.vwModel.movieList[indexPath.row].trailersContent)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //updateHeaderLayout()
        let yPos: CGFloat = -scrollView.contentOffset.y
        
        if yPos > 0 {
            var imgRect: CGRect? = headerView?.frame
            imgRect?.origin.y = scrollView.contentOffset.y
            imgRect?.size.height = headerHeight/2 + yPos  - headerHeight/2
            headerView?.frame = imgRect!
            self.tableVw.sectionHeaderHeight = (imgRect?.size.height)!
        }
        print(yPos)
        if yPos < 116 {
            player?.pauseVideo()
        } else {
            player?.playVideo()
        }
    }
}

extension MovieDetilsVC: PlayerDelegate {
    func playerDidBecomeReady(playerType: VideoPlayer) {
        self.headerView.imgVwCover.transform = CGAffineTransform(scaleX: 1.5, y: 2.2)
        player?.playVideo()
    }
    
    func player(playerType: VideoPlayer, didUpdateTime playTime: TimeInterval) {
        
    }
    
    func player(playerType: VideoPlayer, didUpdateState state: VideoPlayerStatus) {
        switch state {
        case .unknown:
            print("Unknown")
        case .playing :
            break
        case .paused :
            break
        case .buffering :
            break
        case .ended :
            self.headerView.imgVwCover.transform = CGAffineTransform(scaleX: 1, y: 1)
            //self.headerView.imgVwCover.isHidden = false
            switch playerType {
            case .youtube(let ytPlayer):
                ytPlayer.removeFromSuperview()
                self.player = nil                
            default:
                break
            }
        case .failed(_):
            print("failed")
        default :
            break
        }
    }
    
    func player(playerDuration: TimeInterval) {
        
    }
    
    
}
