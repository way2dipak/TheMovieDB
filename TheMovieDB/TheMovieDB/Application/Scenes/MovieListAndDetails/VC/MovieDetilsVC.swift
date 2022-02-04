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
        return 204//view.frame.height/2//207
    }()
    var movieID = 0
    private let vwModel = MovieDetailsVwModel()
    private var player: PlayerHandler?
    
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
            self.vwModel.getStreamURL(for: self.vwModel.getVideoForHeader())
            self.vwModel.playVideo = { [weak self] url in
                guard let self = self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
               // self.player = PlayerHandler(videoId: url, parentView: self.headerView.imgVwCover, playerDelegate: self, showContentFill: true)
                }
            }
            self.tableVw.reloadData()
            self.tableVw.toggleDisplayWithAnimation(true)
        }
    }
    
    func registerNIB() {
        tableVw.register(MovieCarouselCell.nib, forCellReuseIdentifier: MovieCarouselCell.identifier)
        tableVw.register(StorylineCell.nib, forCellReuseIdentifier: StorylineCell.identifier)
        tableVw.register(MovieDetailsHeaderCell.nib, forCellReuseIdentifier: MovieDetailsHeaderCell.identifier)
    }
    
    @IBAction func onTapBackBtn(_ sender: UIButton) {
        self.player?.stopVideo()
        self.player = nil
        dismissVC()
    }
    
    func setupHeaderView() {
        headerView = MovieDetailsHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight))
        tableVw.tableHeaderView = nil
        tableVw.estimatedSectionHeaderHeight = headerHeight
        tableVw.sectionHeaderHeight = UITableView.automaticDimension
        tableVw.addSubview(headerView)
        tableVw.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 20, right: 0)
        tableVw.contentOffset = CGPoint(x: 0, y: -headerHeight)
    }
    
    deinit {
        headerView = nil
        player = nil
        tableVw = nil
        print("Movie details vc deinited")
    }
    
}

extension MovieDetilsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return  1
        } else {
            return vwModel.movieList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsHeaderCell.identifier) as! MovieDetailsHeaderCell
            cell.details = vwModel.movieDetails
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: StorylineCell.identifier) as! StorylineCell
            cell.storyLine = vwModel.movieDetails?.overview ?? ""
            return cell
        default:
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
            self.tableVw.sectionHeaderHeight = (imgRect?.size.height) ?? 240.0
        }
        print(yPos)
        if yPos < 116 {
            player?.pauseVideo()
        } else {
            player?.playVideo()
        }
    }
}

extension MovieDetilsVC: VideoPlayerDelegate {
    func playerDidBecomeReady(playerType: VideoPlayer) {
        self.headerView.imgVwCover.transform = CGAffineTransform(scaleX: 1, y: 1)
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
            case .custom(let avPlayer):
                avPlayer.view.removeFromSuperview()
                player = nil
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
