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
    lazy var headerHeight: CGFloat = {
        return 204//view.frame.height/2//207
    }()
    var movieID = 0
    var type: MediaType = .movie
    private let vwModel = MovieDetailsVwModel()
    private var player: PlayerHandler?
    
    var playPauseHandler: ((Bool) -> ())?
    
    var headerCell: MovieDetailsHeaderCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        loadDetails(movieId: movieID, type: type)
    }
    
    func loadDetails(movieId: Int, type: MediaType) {
        vwModel.getMovieDetails(by: movieId, and: type)
        vwModel.refreshUI = { [weak self] in
            guard let self = self else { return }
            self.tableVw.reloadData()
            self.tableVw.toggleDisplayWithAnimation(true)
        }
        self.vwModel.playVideo = { [weak self] url in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                if self.headerCell == nil { return }
                self.player = PlayerHandler(videoId: url, parentView: self.headerCell!.imgVwBackdrop, playerDelegate: self, showContentFill: true)
            }
        }
    }
    
    func registerNIB() {
        tableVw.register(MovieCarouselCell.nib, forCellReuseIdentifier: MovieCarouselCell.identifier)
        tableVw.register(MovieDetailsHeaderCell.nib, forCellReuseIdentifier: MovieDetailsHeaderCell.identifier)
    }
    
    @IBAction func onTapBackBtn(_ sender: UIButton) {
        self.player?.stopVideo()
        self.player = nil
        dismissVC()
    }
    
    deinit {
        player = nil
        tableVw = nil
        print("Movie details vc deinited")
    }
    
}

extension MovieDetilsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vwModel.movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let details = vwModel.movieList[indexPath.row]
        switch details.contentType {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsHeaderCell.identifier) as! MovieDetailsHeaderCell
            self.headerCell = cell
            cell.details = vwModel.movieDetails
            cell.playhandler = { [weak self] in
                guard let self = self else { return }
                cell.btnPlay.showLoading()
                self.vwModel.getStreamURL(for: self.vwModel.getVideoForHeader())
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCarouselCell.identifier) as! MovieCarouselCell
            cell.details = vwModel.movieList[indexPath.row]
            
            cell.arrowHandler = { [weak self] in
                guard let self = self else { return }
                self.player = nil
              //  MovieListNavigator().showMovieListVC(with: self.vwModel.movieList[indexPath.row].content, type: self.vwModel.movieList[indexPath.row].contentType)
            }
            
            cell.selectedContentHandler = { [weak self] movieId, type in
                guard let self = self else { return }
                self.player = nil
                MovieListNavigator().showMovieDetailsVC(with: movieId, type: type)
            }
            
//            cell.trailerContentHandler = { [weak self] videoId in
//                guard let self = self else { return }
//                self.player = nil
//                MovieListNavigator().showVideoPlayerVC(with: self.vwModel.movieDetails, videoID: videoId, videoList: self.vwModel.movieList[indexPath.row].trailersContent)
//            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPos: CGFloat = -scrollView.contentOffset.y
        if yPos < -202 {
            player?.pauseVideo()
        } else {
            player?.playVideo()
        }
    }
}

extension MovieDetilsVC: VideoPlayerDelegate {
    func playerDidBecomeReady(playerType: VideoPlayer) {
        player?.playVideo()
        headerCell?.btnPlay.hideLoading()
        headerCell?.btnPlay.isHidden = true
        headerCell?.imgVwBackdrop.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
    }
    
    func player(playerType: VideoPlayer, didUpdateTime playTime: TimeInterval) {
        
    }
    
    func player(playerType: VideoPlayer, didUpdateState state: VideoPlayerStatus) {
        switch state {
        case .unknown:
            print("Unknown")
        case .playing :
            print("playing")
            break
        case .paused :
            print("paused")
            break
        case .buffering :
            print("buffering")
            break
        case .ended :
            print("ended")
            headerCell?.imgVwBackdrop.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            headerCell?.btnPlay.isHidden = false
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
