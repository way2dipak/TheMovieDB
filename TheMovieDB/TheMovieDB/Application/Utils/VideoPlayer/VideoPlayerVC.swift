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
    @IBOutlet weak var vwError: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var vwControllerBtn: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel! {
        didSet {
            //lblDescription.setLineHeight(lineHeight: 4)
        }
    }
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var btnRewind: UIButton!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var colvw: UICollectionView!
    @IBOutlet weak var colvwBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgVwThumb: UIImageView?
    @IBOutlet weak var vwVideoList: UIView!
    
    var details: MovieResultList?
    var duration: TimeInterval {
        return playerHandler?.getDuration() ?? 0
    }
    var videoURL: String = ""
    
    var movieList = [MovieResultList]()
    
    private var currentTime: TimeInterval = 0 {
        didSet {
            if currentTime > 0 {
                //lblDuration.text = currentTime.stringInHoursMinsSeconds() + "/" + duration
            } else {
                //lblDuration.text = zeroTime + "/" + duration
            }
            UIView.animate(withDuration: 2) {
                self.slider.setValue(Float(Double(self.currentTime) / Double(self.playerHandler?.getDuration() ?? 0)), animated: true)
            }
        }
    }
    
    private var timer: Timer?
    
    var videoId = ""
    
    private var isControllerActive = true
    private var isPlaying = false
    private var playerHandler: PlayerHandler?
    private var vwModel = MovieDetailsVwModel()
    private var configuration: VideoPlayerConfiguration = .loading {
        didSet {
            switch configuration {
            case .loading:
                vwError.isHidden = true
                vwController.alpha = 0
                imgVwThumb?.isHidden = false
                spinner.isHidden = false
                spinner.startAnimating()
            case .playing:
                resetTimer()
                vwError.isHidden = true
                imgVwThumb?.isHidden = true
                spinner.stopAnimating()
                spinner.isHidden = true
                vwControllerBtn.alpha = 1
            case .completed:
                spinner.stopAnimating()
                spinner.isHidden = true
                vwController.alpha = 1
                //toggleBtnControllerState(state: .completed)
            case .failed(let error):
                vwError.isHidden = false
                spinner.stopAnimating()
                spinner.isHidden = true
                vwController.alpha = 1
                vwControllerBtn.alpha = 0
                slider.alpha = 0
                // display error
            }
        }
    }
    
    var swipeUp = UISwipeGestureRecognizer()
    var swipeDown = UISwipeGestureRecognizer()

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgVwThumb?.loadImageWithUrl(with: videoId, placeholderImage: #imageLiteral(resourceName: "posterPlaceholder") , type: .youtube, completed: nil)
        colvw.register(MovieTrailersCell.nib, forCellWithReuseIdentifier: MovieTrailersCell.identifier)
        rotateToLandScapeDevice()
        addGesture()
        lblTitle.text = details?.originalTitle ?? ""
        //lblDescription.text = details?.overview ?? ""
        checkVideo(videoId: videoId)
    }
    
    func checkVideo(videoId: String) {
        configuration = .loading
        vwModel.getStreamURL(for: videoId)
        self.vwModel.playVideo = { [weak self] url in
            guard let self = self else { return }
            self.videoURL = url
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.playerHandler = PlayerHandler(videoId: url, parentView: self.vwPlayer, playerDelegate: self, showContentFill: true)
            }
        }
        self.vwModel.videoError = { [weak self] error in
            guard let self = self else { return }
            self.configuration = .failed(error)
        }
    }
    
    private func seek(toSeconds: Double) {
        playerHandler?.seek(toSeconds: toSeconds, allowSeekAhead: true)
        currentTime = toSeconds
    }
    
    @IBAction func onTapBackBtn(_ sender: UIButton) {
        timer = nil
        playerHandler?.stopVideo()
        playerHandler = nil
        self.rotateToPotraitDevice()
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
    
    func resetTimer(kill: Bool = false) {
        timer?.invalidate()
        if !kill {
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hideControllerVw), userInfo: nil, repeats: false)
        }
    }
    
    @objc func toggleControllerView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.vwController.alpha = self.isControllerActive ? 0 : 1
            self.vwVideoList.alpha = self.isControllerActive ? 0 : 1
            self.isControllerActive.toggle()
        }
        resetTimer()
    }
    
    @objc func hideControllerVw() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.vwController.alpha = 0
            self.vwVideoList.alpha = 0
            self.isControllerActive = false
        }
    }
    
    @objc func togglePlayList(toggle: UISwipeGestureRecognizer) {
        if toggle.direction == .up {
            colvwBottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            resetTimer(kill: true)
        } else {
            colvwBottomConstraint.constant = -80
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            resetTimer(kill: false)
        }
        
    }
}

extension VideoPlayerVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return movieList.count == 1 ? 0 : movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieTrailersCell.identifier, for: indexPath) as! MovieTrailersCell
        cell.imgVw.loadImageWithUrl(with: movieList[indexPath.row].key ?? "", placeholderImage: #imageLiteral(resourceName: "posterPlaceholder") , type: .youtube, completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        playerHandler?.stopVideo()
        imgVwThumb?.loadImageWithUrl(with: movieList[indexPath.row].key ?? "", placeholderImage: nil, type: .youtube, completed: nil)
        checkVideo(videoId: movieList[indexPath.row].key ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 78)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        for cell in colvw.visibleCells {
//            let indexPath = colvw.indexPath(for: cell)!
//            let cellFrame = colvw.layoutAttributesForItem(at: indexPath)!.frame
//            let cellFrameInSuperview = colvw.convert(cellFrame, to: colvw.superview)
//            let distanceFromCenter = colvw.frame.height / 2 - cellFrameInSuperview.midY
//            let maxDistance = colvw.frame.height / 2 + cellFrame.height
//            let alpha = max(0, min(1, (maxDistance - abs(distanceFromCenter)) / maxDistance))
//            cell.alpha = alpha
//        }
    }
}

extension VideoPlayerVC: VideoPlayerDelegate {
    func playerDidBecomeReady(playerType: VideoPlayer) {
        playerHandler?.playVideo()
        vwControllerBtn.alpha = 1
        slider.alpha = 1
        isPlaying = true
    }
    
    func player(playerType: VideoPlayer, didUpdateTime playTime: TimeInterval) {
        currentTime = playTime
    }
    
    func player(playerType: VideoPlayer, didUpdateState state: VideoPlayerStatus) {
        print("didUpdateState: \(state)")
        switch state {
        case .unknown:
            btnPlayPause.isSelected = true
        case .playing :
            configuration = .playing
            btnPlayPause.isSelected = false
            togglePlayList(toggle: swipeDown)
            break
        case .paused :
            btnPlayPause.isSelected = true
            togglePlayList(toggle: swipeUp)
            break
        case .buffering :
            break
        case .ended :
            configuration = .completed
            //btnPlayPause.isSelected = true
            if currentTime < duration {
                slider.value = 1
            }
            togglePlayList(toggle: swipeUp)
            isPlaying = false
            switch playerType {
            case .youtube(let ytPlayer):
                ytPlayer.removeFromSuperview()
                self.playerHandler = nil
            case .custom(let avPlayer):
                avPlayer.view.removeFromSuperview()
                self.playerHandler = nil
            default:
                break
            }
        case .stoppped:
            slider.setValue(0, animated: false)
            configuration = .loading
            switch playerType {
            case .youtube(let ytPlayer):
                ytPlayer.removeFromSuperview()
                self.playerHandler = nil
            case .custom(let avPlayer):
                avPlayer.view.removeFromSuperview()
                self.playerHandler = nil
                configuration = .completed
            default:
                break
            }
        case .failed(_):
            configuration = .failed("Unknown error occurred")
            btnPlayPause.isSelected = true
            togglePlayList(toggle: swipeUp)
            isPlaying = false
            print("failed")
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
    }
    
    func rotateToLandScapeDevice() {
        AppDelegate.shared.myOrientation = .landscapeLeft
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
    }
    
    func rotateToPotraitDevice() {
        AppDelegate.shared.myOrientation = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
    }
    
    func addGesture() {
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(toggleControllerView))
        tapGesture1.numberOfTouchesRequired = 1
        vwLayer.isUserInteractionEnabled = true
        vwLayer.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(toggleControllerView))
        tapGesture2.numberOfTouchesRequired = 1
        vwController.isUserInteractionEnabled = true
        vwController.addGestureRecognizer(tapGesture2)
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(togglePlayList(toggle:)))
        swipeUp.direction = .up
        vwController.isUserInteractionEnabled = true
        vwController.addGestureRecognizer(swipeUp)
        
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(togglePlayList(toggle:)))
        swipeDown.direction = .down
        vwController.isUserInteractionEnabled = true
        vwController.addGestureRecognizer(swipeDown)
    }
    
    func toggleBtnControllerState(state: VideoPlayerConfiguration) {
        switch state {
        case .loading:
            btnRewind.isEnabled = true
            btnForward.isEnabled = true
            btnPlayPause.setImage(#imageLiteral(resourceName: "btnPause"), for: .normal)
        case .playing:
            btnRewind.isEnabled = true
            btnForward.isEnabled = true
            btnPlayPause.setImage(#imageLiteral(resourceName: "BtnPause"), for: .normal)
        case .completed:
            btnRewind.isEnabled = false
            btnForward.isEnabled = false
            btnPlayPause.setImage(#imageLiteral(resourceName: "btnReplay"), for: .normal)
        case .failed(_):
            break
        }
    }
}

extension VideoPlayerVC {
    enum VideoPlayerConfiguration {
        case loading
        case playing
        case completed
        case failed(String)
    }
}
