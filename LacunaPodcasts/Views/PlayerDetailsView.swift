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
import MediaPlayer

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
    
    deinit {
        // Don't forget to remove self as an observer.
        // Otherwise, object will be forever retained.
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
        player.removeObserver(self, forKeyPath: "rate")
        
        print("PlayerDetailsView memory being reclaimed...")
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
            
            
            
            
            // MAKE INTO ATTRIBUTED STRING?
            if let description = episode.contentEncoded {
                episodeDescriptionTextView.attributedText = description.convertHtml()
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            setupNowPlayingInfo()
            setupAudioSession()
            playEpisode()
            
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            //episodeImageView.sd_setImage(with: url)
            episodeImageView.sd_setImage(with: url) { (image, error, cache, url) in
                let image = self.episodeImageView.image ?? UIImage()
                let artworkItem = MPMediaItemArtwork(boundsSize: .zero, requestHandler: { (size) -> UIImage in
                    return image
                })
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = artworkItem
            }
            //let colors = episodeImageView.image?.getColors()
        }
    }
    
    //MARK: - Setup Audio
    
    fileprivate func setupNowPlayingInfo() {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    fileprivate func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch let sessionErr {
            print("Failed to activate session:", sessionErr)
        }
    }

    fileprivate func setupRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.player.play()
            print("play:", CMTimeGetSeconds(self.player.currentTime()))
            
            self.isPlaying = true
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            print("pause:", CMTimeGetSeconds(self.player.currentTime()))
            
            self.isPlaying = false
            return .success
        }
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.handlePlayPause()
            print("playpause:", CMTimeGetSeconds(self.player.currentTime()))
            
            return .success
        }
        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipForwardCommand.preferredIntervals = [15]
        commandCenter.skipForwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.seekToCurrentTime(delta: 15)
            return .success
        }
        commandCenter.skipBackwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.preferredIntervals = [15]
        commandCenter.skipBackwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.seekToCurrentTime(delta: -15)
            return .success
        }
//
//        commandCenter.nextTrackCommand.isEnabled = true
//        commandCenter.nextTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
//            self.handleNextTrack()
//            return .success
//        }
//        commandCenter.previousTrackCommand.isEnabled = true
//        commandCenter.previousTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
//            self.handlePreviousTrack()
//            return .success
//        }
    }
    
    var playlistEpisodes = [Episode]()
//    fileprivate func handleNextTrack() {
//        changeTrack(nextTrack: true)
//    }
//    fileprivate func handlePreviousTrack() {
//        changeTrack(nextTrack: false)
//    }
//
//    fileprivate func changeTrack(nextTrack: Bool) {
//        let offset = nextTrack ? 1 : playlistEpisodes.count - 1
//        if playlistEpisodes.count == 0 { return }
//        let currentEpisodeIndex = playlistEpisodes.firstIndex { (ep) -> Bool in
//            return episode.title == ep.title && episode.author == ep.author
//        }
//        guard let index = currentEpisodeIndex else { return }
//        self.episode = playlistEpisodes[(index + offset) % playlistEpisodes.count]
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    
    //MARK: - Notification Center
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    @objc fileprivate func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
        if type == AVAudioSession.InterruptionType.began.rawValue {
            isPlaying = false
        } else {
            guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
                player.play()
                isPlaying = true
            }
        }
    }
    
    fileprivate func setupObservers() {
        player.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" {
            if player.rate == 0 { isPlaying = false }
        }
    }
    
    
    
    
    
        
        
        
            

    
    
    
    
    
    
    
    //MARK: - Setup
    
    func setup() {
        setupMiniDurationBar()
        
        setupRemoteControl()
        
        
        setupNotifications()
        
        observePlayerCurrentTime()
        observeBoundaryTime()
        setupObservers()
    }
    
    private func setupMiniDurationBar() {
        miniProgressBar.isUserInteractionEnabled = false
        miniProgressBar.setThumbImage(UIImage(), for: .normal)
        miniProgressBar.minimumTrackTintColor = .black
        miniProgressBar.maximumTrackTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    //MARK: - Time Observers
    
    var timeObserverToken: Any?
    var boundaryTimeObserverToken: Any?
    
    fileprivate func observeBoundaryTime() {
        // observe when episodes start playing
        let time = CMTime(seconds: 1, preferredTimescale: 3)
        let times = [NSValue(time: time)]
        boundaryTimeObserverToken = player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            print("Episode started playing...")
        }
    }
    
    func removeBoundaryTimeObserver() {
        if let timeObserverToken = boundaryTimeObserverToken {
            print("Boundary Time Observer Removed")
            player.removeTimeObserver(timeObserverToken)
            self.boundaryTimeObserverToken = nil
        }
    }
    
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            print("Periodic Time Observer Token Removed")
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    fileprivate func observePlayerCurrentTime() {
        // notify every half second
        let interval = CMTime(seconds: 1, preferredTimescale: 2)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            if let self = self {
                let currentTime = self.player.currentTime()
                self.updateTimeLabels(currentTime)
                self.updateCurrentTimeSlider()
                self.setupLockscreenCurrentTime()
            }
        }
    }
    
    fileprivate func setupLockscreenCurrentTime() {
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
        
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        
        nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationInSeconds

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    fileprivate func updateTimeLabels(_ currentTime: CMTime) {
        guard let duration = player.currentItem?.duration else { return }
        let timeRemaining = duration - currentTime
        currentTimeLabel.text = currentTime.toDisplayString()
        durationLabel.text = "-" + timeRemaining.toDisplayString()
    }
    
    fileprivate func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        DispatchQueue.main.async {
            self.currentTimeSlider.value = Float(percentage)
            self.miniProgressBar.value = Float(percentage)
        }
    }
    
  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - Gesture Recognizers
    
    var animationProgress: CGFloat = 0
    var dragStartPosition: CGFloat = 0
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize))
        return tapGesture
    }()
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        return panGesture
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        addGestureRecognizer(tapGesture)
        addGestureRecognizer(panGesture)
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    //MARK: - Set Gradient Background
    
//    fileprivate func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = containerView.bounds
//        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
//        gradientLayer.locations = [0.6, 1.8]
//        containerView.layer.insertSublayer(gradientLayer, at: 0)
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - Play Episode
    
    fileprivate let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    fileprivate func localFilePath(for url: URL) -> URL {
      return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    fileprivate func playEpisode() {
        var trackUrl: URL
        
        if episode.fileUrl != nil {
            print("Playing episode with file url:", episode.fileUrl ?? "")

            guard let fileUrl = URL(string: episode.fileUrl ?? "") else { return }
            let url = localFilePath(for: fileUrl)
            trackUrl = url
               
        } else {
            print("Playing episode with stream url:", episode.streamUrl)
            
            guard let url = URL(string: episode.streamUrl) else { return }
            trackUrl = url
        }
        let playerItem = AVPlayerItem(url: trackUrl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    private var player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    
    













    
    //MARK: - User Actions
    
    private lazy var episodeImageTapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEpisodeImageTap))
        return tapGesture
    }()
    
    @objc fileprivate func handleEpisodeImageTap() {
        print("tapped image")
    }
    
    let episodeImageContainerRadius: CGFloat = 16.0
    
    // EPISODE DESCRIPTION
    
    @IBOutlet weak var episodeDescriptionTextViewContainer: UIView! {
        didSet {
            episodeDescriptionTextViewContainer.layer.cornerRadius = episodeImageContainerRadius
        }
    }
    @IBOutlet weak var episodeDescriptionTextView: EpisodeDescriptionTextView!
    @IBOutlet weak var episodeDescriptionTextViewLeading: NSLayoutConstraint!
    
    // Episode Image
    @IBOutlet weak var episodeImageContainer: UIView!
    @IBOutlet weak var episodeImageContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.roundCorners(cornerRadius: episodeImageContainerRadius)
            episodeImageView.addGestureRecognizer(episodeImageTapGesture)
        }
    }
    @IBOutlet weak var episodeImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var episodeImageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var episodeImageViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var playerControlsContainer: UIView!
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var maxiHeader: UIView!
    @IBOutlet weak var maxiHeaderHeight: NSLayoutConstraint!

    // MINI PLAYER
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var miniProgressBar: UISlider!
    @IBOutlet weak var miniTitleLabel: UILabel!
    @IBOutlet weak var miniAuthorLabel: UILabel!
    @IBOutlet weak var miniPlayPauseButton: UIButton! {
        didSet {
            miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    @IBOutlet weak var miniRewindButton: UIButton!
    @IBOutlet weak var miniFastForwardButton: UIButton!

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeSlider: DurationSlider!

    //MARK: - @IBActions
    
    @IBAction func didFastForward(_ sender: Any) { seekToCurrentTime(delta: 15) }
    @IBAction func didRewind(_ sender: Any) { seekToCurrentTime(delta: -15) }

    @IBAction func didChangeCurrentTimeSlider(_ sender: UISlider, forEvent event: UIEvent) {
        
        guard let duration = player.currentItem?.duration else { return }
        let percentage = currentTimeSlider.value
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                print("Touch Began")
                self.removePeriodicTimeObserver()
            case .moved:
                print("Touch Moved")
                updateTimeLabels(seekTime)
            case .ended:
                print("Touch Ended")
                player.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] (value) in
                    self?.miniProgressBar.value = Float(percentage)
                    self?.observePlayerCurrentTime()
                }
            default:
                break
            }
        }
    }
    
    fileprivate func seekToCurrentTime(delta: Int64) {
        let seconds = CMTime(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), seconds)
        player.seek(to: seekTime)
    }
    
    @objc func handlePlayPause() {
        if player.timeControlStatus == .paused {
            self.player.play()
            isPlaying = true
        } else {
            self.player.pause()
            isPlaying = false
        }
    }
    
    @IBAction func didTapDismiss(_ sender: Any) {
        UIApplication.mainTabBarController()?.minimizePlayerDetails()
    }
}


































///        // getting access to the window object from SceneDelegate
///        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
///          let sceneDelegate = windowScene.delegate as? SceneDelegate
///        else { return }
///        //let viewcontroller = UIViewController()
///        let mainTabBarController = MainTabBarController()
///        //viewcontroller.view.backgroundColor = .blue
///        sceneDelegate.window?.rootViewController = mainTabBarController



////MARK: - Episode Artwork Animations
//
//fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.95, y: 0.95)
//fileprivate func enlargeEpisodeImageView() {
//    animateEpisodeArtwork { self.episodeImageView.transform = .identity }
//}
//fileprivate func shrinkEpisodeImageView() {
//    animateEpisodeArtwork { self.episodeImageView.transform = self.shrunkenTransform }
//}
//fileprivate func animateEpisodeArtwork(animations: @escaping () -> Void) {
//    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: animations, completion: nil)
//}
