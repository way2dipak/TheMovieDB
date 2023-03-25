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
import AVFoundation
    
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
    case custom(CustomAVPlayer)
    case none
    var type: String {
        switch self {
        case .youtube(_):
            return "youtube"
        case .custom(_):
        return "avPlayer"
        case .none:
            return "none"
        }
    }
}
    
protocol VideoPlayerDelegate: AnyObject {
    func playerDidBecomeReady(playerType: VideoPlayer)
    func player(playerType: VideoPlayer, didUpdateTime playTime: TimeInterval)
    func player(playerType: VideoPlayer, didUpdateState state: VideoPlayerStatus)
    func player(playerDuration: TimeInterval)
    //func player(playerType : VideoPlayer, didFailWithError : NSError?)
}
    
class PlayerHandler {
    var showContentFill = false
    var playerType: VideoPlayer = .none
    weak var delegate: VideoPlayerDelegate?
    var videoID: String
    var playerSuperView: UIView
    var playerStatus: VideoPlayerStatus = .unknown {
        didSet {
            if isVideoStopped {
                delegate?.player(playerType: playerType, didUpdateState: .stoppped)
                return
            }
            delegate?.player(playerType: playerType, didUpdateState: playerStatus)
        }
    }
    var isPlayerReady = false
    var isVideoStopped = false
    
    static let youtubeErrorDomain = "com.youtube.embibe"
    
    init(videoId: String, parentView: UIView, playerDelegate: VideoPlayerDelegate? = nil, showContentFill: Bool = false) {
        delegate = playerDelegate
        videoID = videoId
        playerSuperView = parentView
        self.showContentFill = showContentFill
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
        configurePlayer()
    }
    
    func configurePlayer() {
        //setupYoutubePlayer()
        setupNormalVideoPlayer()
    }
    
    func setupNormalVideoPlayer() {
        let player = CustomAVPlayer(seekTolerance: 0)
        if showContentFill {
            player.fillMode = .fill
        }
        player.delegate = self
        player.view.translatesAutoresizingMaskIntoConstraints = false
        playerSuperView.insertSubview(player.view, at: 0)
        var viewBindingsDict = [String: Any]()
        viewBindingsDict["subView"] = player.view
         playerSuperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
         playerSuperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                              options: [], metrics: nil, views: viewBindingsDict))
        if let videoURL = URL(string: videoID) {
            player.set(AVURLAsset(url: videoURL))
            playerType = .custom(player)
        }
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
        //let playerParams = ["playsinline": 1, "rel": 0, "modestbranding": 0, "iv_load_policy": 3, "autoplay": 1, "controls": 0, "showinfo": 0]
        let playerParams: [String: Any] = [
            "controls" : "0",
            "showinfo" : "0",
            "autoplay": "1",
            "rel": "0",
            "modestbranding": "0",
            "iv_load_policy" : "3",
            "fs": "0",
            "playsinline" : "1"
        ]
        player.load(videoId: videoID, playerVars: playerParams)
        player.isOpaque = false
        player.backgroundColor = .black
        //player.scrollView.backgroundColor = UIColor.black
    }
    
    func playVideo() {
        isVideoStopped = false
        switch playerType {
        case .youtube(let ytPlayer):
            ytPlayer.playVideo()
        case .custom(let player):
            player.play()
        default:
            break
        }
    }
    
    func pauseVideo() {
        switch playerType {
        case .youtube(let ytPlayer):
            ytPlayer.pauseVideo()
        case .custom(let player):
            player.pause()
        default:
            break
        }
    }
    
    func stopVideo() {
        isVideoStopped = true
        switch playerType {
        case .youtube(let ytPlayer):
            ytPlayer.stopVideo()
        case .custom(let player):
            player.pause()
        default:
            break
        }
    }
    
    func seek(toSeconds: TimeInterval, allowSeekAhead: Bool) {
        switch playerType {
        case .youtube(let ytPlayer):
            ytPlayer.seek(seekToSeconds: Float(toSeconds), allowSeekAhead: allowSeekAhead)
        case .custom(let player):
            player.seek(to: toSeconds)
            
        default:
            break
        }
    }
    
    func getDuration() -> TimeInterval? {
        switch playerType {
        case .youtube(let ytPlayer):
            //ytPlayer.duration(completionHandler)
            return ytPlayer.duration
        case .custom(let player):
            return player.duration
        default:
            return nil
        }
    }

    deinit {
        print("Player Handler deinited")
    }
}

extension PlayerHandler: VideoPlayerDelegate {
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

extension PlayerHandler: PlayerDelegate {
    
    func playerDidUpdateTime(player: Player) {
        self.delegate?.player(playerType: playerType, didUpdateTime: player.time)
    }
    
    func playerDidUpdateState(player: Player, previousState: PlayerState) {
        
        switch player.state {
        case .unknown:
            playerStatus = .unknown
        case .buffering:
            playerStatus = .buffering
        case .ready:
            if isPlayerReady == false {
                isPlayerReady = true
                playerStatus = .ready
                self.delegate?.player(playerDuration: player.duration)
                self.delegate?.playerDidBecomeReady(playerType: playerType)
            }
        case .playing:
            playerStatus = .playing
        case .paused:
            playerStatus = isVideoStopped ? .stoppped : .paused
        case .ended:
            playerStatus = .ended
        case .failed:
            playerStatus = .failed(player.error)
        default:
            break
        }
    }
    
    func playerDidUpdateBufferedTime(player: Player) {
        
    }
    
    func videoIDFromYouTubeURLString(_ videoURLString: String) -> String? {
        if videoURLString.count == 0 {
            return ""
        }
        let regexString = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        do {
            let regExpression = try NSRegularExpression(pattern: regexString, options: .caseInsensitive)
            let objectiveCString = videoURLString as NSString
            let result = regExpression.firstMatch(in: videoURLString, options: .reportProgress, range: NSMakeRange(0, objectiveCString.length))
            if result == nil {
                return nil
            }
            return objectiveCString.substring(with: (result?.range)!)
        } catch {
            return nil
        }
    }
}
