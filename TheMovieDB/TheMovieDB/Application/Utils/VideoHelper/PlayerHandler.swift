//
//  PlayerHandler.swift
//  TheMovieDB
//
//  Created by DS on 22/05/21.
//

import Foundation
import youtube_ios_player_helper_swift
import AVKit
import MediaPlayer
    
enum VideoPlayerStatus {
    case unknown
    case buffering
    case ready
    case playing
    case stoppped
    case paused
    case ended
    case failed(NSError?)
    
    var stringValue: String {
        switch self {
        case .stoppped:
            return "stopped"
        case .unknown:
            return "unknown"
        case .buffering:
            return "buffering"
        case .ready:
            return "ready"
        case .playing:
            return "playing"
        case .paused:
            return "paused"
        case .ended:
            return "ended"
        case .failed(_):
            return "error"
        }
    }
}
    
enum VideoPlayer {
    case youtube(YTPlayerView)
    case none
    var type: String {
        switch self {
        case .youtube(_):
            return "youtube"
        case .none:
            return "none"
        }
    }
}
    
protocol PlayerDelegate: class {
    func playerDidBecomeReady(playerType: VideoPlayer)
    func player(playerType: VideoPlayer, didUpdateTime playTime: TimeInterval)
    func player(playerType: VideoPlayer, didUpdateState state: VideoPlayerStatus)
    func player(playerDuration: TimeInterval)
    //func player(playerType : VideoPlayer, didFailWithError : NSError?)
}
    
class PlayerHandler: NSObject {
    var showContentFill = false
    var playerType: VideoPlayer = .none
    weak var delegate: PlayerDelegate?
    var videoID: String
    var playerSuperView: UIView
    var playerStatus: VideoPlayerStatus = .unknown {
        didSet {
            delegate?.player(playerType: playerType, didUpdateState: playerStatus)
        }
    }
    var isPlayerReady = false
    
    static let youtubeErrorDomain = "com.youtube.embibe"
    
    init(videoId: String, parentView: UIView, playerDelegate: PlayerDelegate? = nil, showContentFill: Bool = false) {
        delegate = playerDelegate
        videoID = videoId
        playerSuperView = parentView
        self.showContentFill = showContentFill
        super.init()
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
        configurePlayer()
    }
    
    func configurePlayer() {
        setupYoutubePlayer()
    }
    
    func setupYoutubePlayer() {
        let player = YTPlayerView()
        player.delegate = self
        player.translatesAutoresizingMaskIntoConstraints = false
        player.backgroundColor = UIColor.black
        playerSuperView.insertSubview(player, at: 0)
        var viewBindingsDict = [String: Any]()
        viewBindingsDict["subView"] = player
        playerSuperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
        playerSuperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                      options: [], metrics: nil, views: viewBindingsDict))
        playerType = .youtube(player)
        //playerStatus = .unknown
        let playerParams = ["playsinline": 1, "rel": 0, "modestbranding": 0, "iv_load_policy": 3, "autoplay": 1, "controls": 0]
        player.load(videoId: videoID, playerVars: playerParams)
        player.isOpaque = false
        player.backgroundColor = .black
        //player.scrollView.backgroundColor = UIColor.black
    }
    
    func playVideo() {
        switch playerType {
        case .youtube(let ytPlayer):
            ytPlayer.playVideo()
        default:
            break
        }
    }
    
    func pauseVideo() {
        switch playerType {
        case .youtube(let ytPlayer):
            ytPlayer.pauseVideo()
        default:
            break
        }
    }
    
    func stopVideo() {
        switch playerType {
        case .youtube(let ytPlayer):
            ytPlayer.stopVideo()
        default:
            break
        }
    }
    
    func seek(toSeconds: TimeInterval, allowSeekAhead: Bool) {
        switch playerType {
        case .youtube(let ytPlayer):
            ytPlayer.seek(seekToSeconds: Float(toSeconds), allowSeekAhead: allowSeekAhead)
        default:
            break
        }
    }
    
    func getDuration() -> TimeInterval? {
        switch playerType {
        case .youtube(let ytPlayer):
            //ytPlayer.duration(completionHandler)
            return ytPlayer.duration
        default:
            return nil
            break
        }
    }
    
    deinit {
        print("Player Handler deinited")
    }
}

extension PlayerHandler: PlayerDelegate {
    func playerDidBecomeReady(playerType: VideoPlayer) {
        
    }
    
    func player(playerType: VideoPlayer, didUpdateTime playTime: TimeInterval) {
        self.delegate?.player(playerType: playerType, didUpdateTime: playTime)
    }
    
    func player(playerType: VideoPlayer, didUpdateState state: VideoPlayerStatus) {
        self.delegate?.player(playerType: playerType, didUpdateState: state)
    }
    
    func player(playerDuration: TimeInterval) {
        self.delegate?.player(playerType: playerType, didUpdateTime: playerDuration)
    }
    
    
}

extension PlayerHandler: YTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.delegate?.playerDidBecomeReady(playerType: playerType)
        self.delegate?.player(playerDuration: playerView.duration)
        playerStatus = .ready
        self.isPlayerReady = true
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        self.delegate?.player(playerType: playerType, didUpdateTime: Double(playTime))
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .buffering:
            playerStatus = .buffering
        case .playing:
            playerStatus = .playing
        case .paused:
            playerStatus = .paused
            
        case .ended:
            playerStatus = .ended
        case .queued, .unknown:
            playerStatus = .unknown
        default:
            break
        }
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        var userInfo = [String: Any]()
        switch error {
        case .invalidParam:
            userInfo[NSLocalizedDescriptionKey] = "An unknown error occurred."
        case .html5Error:
            userInfo[NSLocalizedDescriptionKey] = "An html5 error occurred."
        case .videoNotFound:
            userInfo[NSLocalizedDescriptionKey] = "Video not found"
        case .notEmbeddable:
            userInfo[NSLocalizedDescriptionKey] = "video is not embeddable"
        default:
            userInfo[NSLocalizedDescriptionKey] = "An unknown error occurred."
        }
        playerStatus = .failed(NSError(domain: PlayerHandler.youtubeErrorDomain, code: 100, userInfo: userInfo))
    }
}
