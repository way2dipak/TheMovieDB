//
//  VideoPlayerVC.swift
//  TheMovieDB
//
//  Created by DS on 01/06/21.
//

import UIKit

class VideoPlayerVC: BaseVC {
    
    @IBOutlet weak var vwPlayer: UIView!
    @IBOutlet weak var vwLayer: UIView!
    @IBOutlet weak var vwController: UIView!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var btnRewind: UIButton!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var colvw: UICollectionView!
    @IBOutlet weak var colvwBottomConstraint: NSLayoutConstraint!
    
    var details: MovieDetailsResponse?
    var duration: TimeInterval {
        return playerHandler?.getDuration() ?? 0
    }
    
    var movieList = [TrailersList]()
    
    private var currentTime: TimeInterval = 0 {
        didSet {
            if currentTime > 0 {
                //lblDuration.text = currentTime.stringInHoursMinsSeconds() + "/" + duration
            } else {
                //lblDuration.text = zeroTime + "/" + duration
            }
            slider.value = Float(Double(currentTime) / Double(playerHandler?.getDuration() ?? 0))
           
        }
    }
    
    private var timer: Timer?
    
    var videoId = ""
    
    private var isControllerActive = true
    private var isPlaying = false
    private var playerHandler: PlayerHandler?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        colvw.register(MovieTrailersCell.nib, forCellWithReuseIdentifier: MovieTrailersCell.identifier)
        rotateToLandScapeDevice()
        addGesture()
        lblTitle.text = details?.originalTitle ?? ""
        lblDescription.text = details?.overview ?? ""
        playerHandler = PlayerHandler(videoId: videoId, parentView: vwPlayer, playerDelegate: self, showContentFill: true)
//        playerHandler?.getDuration({ [weak self] (duration, error) in
//            guard let self = self else { return }
//            self.slider.maximumValue = Float(duration)
//        })
    }
    
    private func seek(toSeconds: Double) {
        playerHandler?.seek(toSeconds: toSeconds, allowSeekAhead: true)
        currentTime = toSeconds
    }
    
    @IBAction func onTapBackBtn(_ sender: UIButton) {
        timer = nil
        dismissVC()
    }
    
    @IBAction func onTapPlayBtn(_ sender: UIButton) {
        resetTimer()
        
    }
    
    @IBAction func onChangeSlider(_ sender: UISlider) {
        resetTimer()
        seek(toSeconds: Double(sender.value) * duration)
    }
    
    @IBAction func onTapRewind(_ sender: UIButton) {
        resetTimer()
        var seekTime = currentTime - Double(10)
        let minValue = Double(slider.minimumValue)
        seekTime = (seekTime / duration) < minValue ? minValue : seekTime
        seek(toSeconds: seekTime)
    }
    
    @IBAction func onTapPlayPause(_ sender: UIButton) {
        resetTimer()
        if isPlaying {
            btnPlayPause.isSelected = true
            playerHandler?.pauseVideo()
        } else {
            btnPlayPause.isSelected = false
            playerHandler?.playVideo()
        }
        isPlaying.toggle()
    }
    
    @IBAction func onTapForward(_ sender: UIButton) {
        resetTimer()
        var seekTime = currentTime + Double(10)
        let maxValue = Double(slider.maximumValue)
        seekTime = (seekTime / duration) > maxValue ? maxValue : seekTime
        seek(toSeconds: seekTime)
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hideControllerVw), userInfo: nil, repeats: false)
    }
    
    @objc func toggleControllerView() {
        UIView.animate(withDuration: 0.3) {
            self.vwController.alpha = self.isControllerActive ? 0 : 1
            self.isControllerActive.toggle()
        }
        resetTimer()
    }
    
    @objc func hideControllerVw() {
        UIView.animate(withDuration: 0.3) {
            self.vwController.alpha = 0
            self.isControllerActive = false
        }
    }
    
    func togglePlayList(toggle: Bool) {
        if toggle {
            colvwBottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            colvwBottomConstraint.constant = -213
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension VideoPlayerVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieTrailersCell.identifier, for: indexPath) as! MovieTrailersCell
        cell.imgVw.loadImageWithUrl(with: movieList[indexPath.row].key ?? "", placeholderImage: #imageLiteral(resourceName: "posterPlaceholder") , type: .youtube, completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        playerHandler?.stopVideo()
        playerHandler = nil
        playerHandler = PlayerHandler(videoId: movieList[indexPath.row].key ?? "", parentView: vwPlayer, playerDelegate: self, showContentFill: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 165, height: 130)
    }
}

extension VideoPlayerVC: PlayerDelegate {
    func playerDidBecomeReady(playerType: VideoPlayer) {
        switch playerType {
        case .youtube(let ytPlayer):
            self.slider.maximumValue = Float(ytPlayer.duration)
        default:
            break
        }
        playerHandler?.playVideo()
        isPlaying = true
    }
    
    func player(playerType: VideoPlayer, didUpdateTime playTime: TimeInterval) {
        currentTime = playTime
    }
    
    func player(playerType: VideoPlayer, didUpdateState state: VideoPlayerStatus) {
        switch state {
        case .unknown:
            print("Unknown")
        case .playing :
            //togglePlayList(toggle: false)
            break
        case .paused :
            //togglePlayList(toggle: true)
            break
        case .buffering :
            break
        case .ended :
            if currentTime < duration {
                slider.value = 1
            }
            //togglePlayList(toggle: true)
            isPlaying = false
            switch playerType {
            case .youtube(let ytPlayer):
                ytPlayer.removeFromSuperview()
                self.playerHandler = nil
            default:
                break
            }
        case .failed(_):
            //togglePlayList(toggle: false)
            isPlaying = false
            print("failed")
        case .stoppped:
            switch playerType {
            case .youtube(let ytPlayer):
                ytPlayer.removeFromSuperview()
                self.playerHandler = nil
            default:
                break
            }
        default :
            break
        }
    }
    
    func player(playerDuration: TimeInterval) {
        slider.maximumValue = 1//Float(playerDuration)
        
    }
}

extension VideoPlayerVC {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            self.rotateToPotraitDevice()
        }

        func rotateToLandScapeDevice() {
            AppDelegate.shared.myOrientation = .landscape
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            UIView.setAnimationsEnabled(true)
        }

        func rotateToPotraitDevice() {
            AppDelegate.shared.myOrientation = .portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIView.setAnimationsEnabled(true)
        }
    
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleControllerView))
        tapGesture.numberOfTouchesRequired = 1
        vwLayer.isUserInteractionEnabled = true
        vwLayer.addGestureRecognizer(tapGesture)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        hideControllerVw()
    }
    
}
