//
//  PlayerDetailsView.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-01.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit
import AVKit
import UIImageColors

class PlayerDetailsView: UIView {
    
    @IBOutlet var containerView: UIView!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        initSubViews()
//        awakeFromNib()
//        setup()
//    }
    
    private func initSubViews() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: containerView.topAnchor),
            self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var isPlaying: Bool! {
        didSet {
            if isPlaying {
                playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            } else {
                playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            }
        }
    }
    
    var episode: Episode! {
        didSet {
            isPlaying = true
            
            titleLabel.text = episode.title
            authorLabel.text = episode.author.uppercased()
            miniTitleLabel.text = episode.title
            miniAuthorLabel.text = episode.author.uppercased()
            
            
//            maximizedHeader.alpha = 0
//            durationSliderContainer.alpha = 0
//            playerControlsContainer.alpha = 0
//            miniPlayerView.alpha = 0
            
            
            

            playEpisode()
            
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            episodeImageView.sd_setImage(with: url)

            //            if let colors = episodeImageView.image?.getColors() {
            //                guard let backgroundColor = colors.background else { return }
            //                guard let primaryColor = colors.primary else { return }
            //                guard let secondaryColor = colors.secondary else { return }
            //                guard let detailColor = colors.detail else { return }
            //                setGradientBackground(colorOne: primaryColor, colorTwo: UIColor.black)
            //            }
            //
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func setup() {

        observePlayerCurrentTime()
        
        // Observe when episodes start playing
        //let time = CMTime(value: 1, timescale: 3) // every 0.3s
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            //self?.enlargeEpisodeImageView()
        }
    }
    
    func handleTapMaximize() {
        guard let mainTabBarController = UIWindow.key?.rootViewController as? MainTabBarController else { return }
        mainTabBarController.maximizePlayerDetails(episode: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        handleTapMaximize()
    }
    
    
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
    
    
    
    


    
    
    
    
    
    
    
    
    
    
    
    deinit {
        print("PlayerDetailsView memory being reclaimed...")
    }
    
    
    
    
    
    
    
    
    
    
    
    

    
    //MARK: - Set Gradient Background
    
    fileprivate func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = containerView.bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.6, 1.8]
        containerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    fileprivate func playEpisode() {
        print("Trying to play episode at url:", episode.streamUrl)
        guard let url = URL(string: episode.streamUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }

    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    private var fadeTimer: Timer?
    var timeObserverToken: Any?
    
    fileprivate func observePlayerCurrentTime() {

        // notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let interval = CMTime(seconds: 1.0, preferredTimescale: timeScale)
        
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            
            if let self = self {
                guard let duration = self.player.currentItem?.duration else { return }
                let currentTime = self.player.currentTime()
                let timeRemaining = duration - currentTime
                self.currentTimeLabel.text = currentTime.toDisplayString()
                self.durationLabel.text = timeRemaining.toDisplayString()
                
                self.updateCurrentTimeSlider()
            }
        }
    }
    
    func removeBoundaryTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - Episode Artwork Animations
    
    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    fileprivate func enlargeEpisodeImageView() {
        animateEpisodeArtwork { self.episodeImageView.transform = .identity }
    }
    fileprivate func shrinkEpisodeImageView() {
        animateEpisodeArtwork { self.episodeImageView.transform = self.shrunkenTransform }
    }
    fileprivate func animateEpisodeArtwork(animations: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: animations, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    fileprivate func updateCurrentTimeSlider() {        
        guard let mainTabBarController = UIWindow.key?.rootViewController as? MainTabBarController else { return }

        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        DispatchQueue.main.async {
            self.currentTimeSlider.value = Float(percentage)
            mainTabBarController.miniDurationBar.value = Float(percentage)
        }
    }
    
    //MARK: - User Actions

    // EPISODE IMAGE
    @IBOutlet weak var episodeImageContainer: UIView!
    @IBOutlet weak var episodeImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var episodeImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var episodeImageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var episodeImageViewBottom: NSLayoutConstraint!
    @IBOutlet weak var episodeImageViewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var durationSliderContainer: UIView!
    @IBOutlet weak var playerControlsContainer: UIView!
    
    @IBOutlet weak var maxiHeader: UIView!
    @IBOutlet weak var maxiHeaderHeight: NSLayoutConstraint!

    // MINI PLAYER
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var miniTitleLabel: UILabel!
    @IBOutlet weak var miniAuthorLabel: UILabel!
    @IBOutlet weak var miniPlayPauseButton: UIButton! {
        didSet {
            miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    @IBOutlet weak var miniRewindButton: UIButton!
    @IBOutlet weak var miniFastForwardButton: UIButton!

    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.roundCorners(cornerRadius: 16)
            //episodeImageView.transform = shrunkenTransform
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeSlider: DurationSlider!
    
    //MARK: - @IBActions
    
    @IBAction func didChangeCurrentTimeSlider(_ sender: Any) {
        guard let duration = player.currentItem?.duration else { return }
        let percentage = currentTimeSlider.value
        let seekTimeInSeconds = Float64(percentage) * CMTimeGetSeconds(duration)
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: Int32(NSEC_PER_SEC))
        
        // update current time and duration labels
        currentTimeLabel.text = seekTime.toDisplayString()
        let timeRemaining = duration - seekTime
        durationLabel.text = timeRemaining.toDisplayString()
        
        player.seek(to: seekTime)
    }
    
    @IBAction func didFastForward(_ sender: Any) {
        seekToCurrentTime(delta: 15)
    }
    
    @IBAction func didRewind(_ sender: Any) {
        seekToCurrentTime(delta: -15)
    }
    
    fileprivate func seekToCurrentTime(delta: Int64) {
        guard let duration = self.player.currentItem?.duration else { return }
        let seconds = CMTime(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), seconds)
        let value = Float(CMTimeGetSeconds(seekTime) / CMTimeGetSeconds(duration))
        currentTimeSlider.setValue(value, animated: true)
        currentTimeLabel.text = seekTime.toDisplayString()
        player.seek(to: seekTime)
    }
    
//    @IBAction func didChangeVolume(_ sender: UISlider) {
//        player.volume = sender.value
//    }
    
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @objc func handlePlayPause() {
        if player.timeControlStatus == .paused {
            observePlayerCurrentTime()
            fadeTimer = player.fadeVolume(from: 0, to: 1, duration: 0.5, completion: {
                self.player.play()
            })
            isPlaying = true
            //enlargeEpisodeImageView()
            
        } else {
            removeBoundaryTimeObserver()
            fadeTimer = player.fadeVolume(from: player.volume, to: 0, duration: 0.5, completion: {
                self.player.pause()
            })
            isPlaying = false
            //shrinkEpisodeImageView()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    


    @IBAction func didTapDismiss(_ sender: Any) {
///        // getting access to the window object from SceneDelegate
///        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
///          let sceneDelegate = windowScene.delegate as? SceneDelegate
///        else { return }
///        //let viewcontroller = UIViewController()
///        let mainTabBarController = MainTabBarController()
///        //viewcontroller.view.backgroundColor = .blue
///        sceneDelegate.window?.rootViewController = mainTabBarController

        guard let mainTabBarController = UIWindow.key?.rootViewController as? MainTabBarController else { return }
        mainTabBarController.minimizePlayerDetails()
    }
}
