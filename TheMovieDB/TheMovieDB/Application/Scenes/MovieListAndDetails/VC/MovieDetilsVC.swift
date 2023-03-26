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
            tableVw.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
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
    var headerIpadCell: MovieDetailsHeaderIPadCell?

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
                if isIphone {
                    if self.headerCell == nil { return }
                    self.player = PlayerHandler(videoId: url, parentView: self.headerCell!.imgVwBackdrop, playerDelegate: self, showContentFill: true)
                } else {
                    if self.headerIpadCell == nil { return }
                    self.player = PlayerHandler(videoId: url, parentView: self.headerIpadCell!.imgVwBackdrop, playerDelegate: self, showContentFill: true)
                }
            }
        }
    }
    
    func registerNIB() {
        tableVw.register(MovieCarouselCell.nib, forCellReuseIdentifier: MovieCarouselCell.identifier)
        if isIphone {
            tableVw.register(MovieDetailsHeaderCell.nib, forCellReuseIdentifier: MovieDetailsHeaderCell.identifier)
        } else {
            tableVw.register(MovieDetailsHeaderIPadCell.nib, forCellReuseIdentifier: MovieDetailsHeaderIPadCell.identifier)
        }
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
    
    func getThumbImage() -> String {
        let index = vwModel.movieList.firstIndex(where: { items in
            return items.sectionTitle?.lowercased() ?? "" == "trailers"
        })
        if !vwModel.movieList.isEmpty {
            return vwModel.movieList[index ?? 0].sectionData?.randomElement()?.key ?? ""
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vwModel.movieList.count == 0 { return 10 }
        return vwModel.movieList.count
    }
    
    func tableVw(_ tableView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if isIphone {
                let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsHeaderCell.identifier) as! MovieDetailsHeaderCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsHeaderIPadCell.identifier) as! MovieDetailsHeaderIPadCell
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCarouselCell.identifier) as! MovieCarouselCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if vwModel.movieList.count == 0 {
            return tableVw(tableView, skeletonCellForRowAt: indexPath)
        }
        
        let details = vwModel.movieList[indexPath.row]
        switch details.contentType {
        case .header:
            if isIphone {
                let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsHeaderCell.identifier) as! MovieDetailsHeaderCell
                self.headerCell = cell
                cell.startAnimation(false)
                cell.details = vwModel.movieDetails
                /*
                if let imgUrl = vwModel.movieList.filter({ $0.sectionTitle ?? "" == "Trailers" }).first?.sectionData?.randomElement()?.key {
                    cell.imgVwBackdrop.loadImageWithUrl(with: imgUrl,
                                                        placeholderImage: nil,
                                                        type: .youtube,
                                                        completed: nil)
                } else {
                    cell.imgVwBackdrop.loadImageWithUrl(with: vwModel.movieDetails?.backdropPath,
                                                        placeholderImage: nil,
                                                        type: .normal,
                                                        quality: .hd,
                                                        completed: nil)
                }
                 */
                cell.playhandler = { [weak self] in
                    guard let self = self else { return }
                    cell.btnPlay.showLoading()
                    self.vwModel.getStreamURL(for: self.vwModel.getVideoForHeader())
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsHeaderIPadCell.identifier) as! MovieDetailsHeaderIPadCell
                self.headerIpadCell = cell
                cell.startAnimation(false)
                cell.details = vwModel.movieDetails
                cell.playhandler = { [weak self] in
                    guard let self = self else { return }
                    cell.btnPlay.showLoading()
                    self.vwModel.getStreamURL(for: self.vwModel.getVideoForHeader())
                }
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCarouselCell.identifier) as! MovieCarouselCell
            cell.startAnimation(false)
            cell.details = vwModel.movieList[indexPath.row]
            cell.arrowHandler = { [weak self] in
                guard let self = self else { return }
                self.player = nil
                MovieListNavigator().showMovieListVC(with: self.vwModel.movieList[indexPath.row].sectionData ?? [],
                                                     type: self.vwModel.movieList[indexPath.row].contentType,
                                                     sectionName: self.vwModel.movieList[indexPath.row].sectionTitle ?? "")
            }
            
            cell.selectedContentHandler = { [weak self] movieId, type in
                guard let self = self else { return }
                self.player = nil
                MovieListNavigator().showMovieDetailsVC(with: movieId, type: type)
            }
            
            cell.trailerContentHandler = { [weak self] videoId in
                guard let self = self else { return }
                self.player = nil
                MovieListNavigator().showVideoPlayerVC(with: self.vwModel.movieDetails, videoID: videoId, videoList: self.vwModel.movieList[indexPath.row].sectionData ?? [])
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPos: CGFloat = -scrollView.contentOffset.y
        //print(yPos)
        if yPos < -110 {
            player?.pauseVideo()
        } else {
            player?.playVideo()
        }
    }
}

extension MovieDetilsVC: VideoPlayerDelegate {
    func playerDidBecomeReady(playerType: VideoPlayer) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.player?.playVideo()
        }
        if isIphone {
            headerCell?.btnPlay.hideLoading()
            headerCell?.btnPlay.isHidden = true
            headerCell?.imgVwBackdrop.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        } else {
            headerIpadCell?.btnPlay.hideLoading()
            headerIpadCell?.btnPlay.isHidden = true
            headerIpadCell?.imgVwBackdrop.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        }
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
        case .ended, .failed(_) :
            print("ended")
            if isIphone {
                headerCell?.imgVwBackdrop.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                headerCell?.btnPlay.hideLoading()
                headerCell?.btnPlay.isHidden = false
            } else {
                headerCell?.imgVwBackdrop.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                headerIpadCell?.btnPlay.hideLoading()
                headerIpadCell?.btnPlay.isHidden = false
            }
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
        default :
            break
        }
    }
    
    func player(playerDuration: TimeInterval) {
        
    }
    
    
}
