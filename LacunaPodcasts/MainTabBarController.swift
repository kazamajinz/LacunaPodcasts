//
//  MainTabBarController.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-06-28.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = false
        tabBar.tintColor = .black
        setupViewControllers()
        setupPlayerDetailsView()
        setupProgressBar()
    }
    
    //MARK: - ANIMATIONS: Maximize and Minimize Player
    
    enum AnimationType {
        case animateIn, animateOut
    }
    
    let duration: TimeInterval = 0.3
    var delay: TimeInterval {
        return duration * 0.8
    }
    
    fileprivate func animateMiniPlayerView(type: AnimationType) {
        let delay: TimeInterval = type == .animateIn ? self.delay : 0
        let alpha: CGFloat = type == .animateIn ? 1 : 0
        UIView.animate(withDuration: 0.1, delay: delay, options: .curveEaseOut, animations: {
            self.playerDetailsView.miniPlayerView.alpha = alpha
        }, completion: nil)
    }
    
    fileprivate func animatePlayerControls(type: AnimationType) {
        
        let delay: TimeInterval = type == .animateIn ? self.delay : 0
        let alpha: CGFloat = type == .animateIn ? 1 : 0
        UIView.animate(withDuration: 0.1, delay: delay, options: .curveEaseOut, animations: {
            self.playerDetailsView.maxiHeader.alpha = alpha
            self.playerDetailsView.durationSliderContainer.alpha = alpha
            self.playerDetailsView.playerControlsContainer.alpha = alpha
        }, completion: nil)
    }

    fileprivate func configureEpisodeImageInPosition(maximize: Bool) {

        let episodeImageContainerWidth = self.playerDetailsView.episodeImageContainer.bounds.width
        let maximizedHeaderHeight: CGFloat = maximize ? 52 : 0
        let episodeImageViewLeadingInset: CGFloat = maximize ? 24 : 0
        let episodeImageViewHeight: CGFloat = maximize ? episodeImageContainerWidth - 24 * 2 : 64
        let episodeImageCornerRadius: CGFloat = maximize ? 16 : 0
        
        self.playerDetailsView.maxiHeaderHeight.constant = maximizedHeaderHeight
        self.playerDetailsView.episodeImageViewHeight.constant = episodeImageViewHeight
        self.playerDetailsView.episodeImageViewLeading.constant = episodeImageViewLeadingInset
        self.playerDetailsView.episodeImageView.roundCorners(cornerRadius: episodeImageCornerRadius)
    }
    
    private func maximizeEpisodeImage() {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.configureEpisodeImageInPosition(maximize: true)
            self.view.layoutIfNeeded()
            self.hideTabBar()
        }, completion: nil)
    }
    
    private func minimizeEpisodeImage() {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.configureEpisodeImageInPosition(maximize: false)
            self.view.layoutIfNeeded()
            self.showTabBar()
        }, completion: nil)
    }

    @objc func minimizePlayerDetails() {
        toggleTopAnchorConstraints(maximizingPlayer: false)
        animatePlayerControls(type: .animateOut)
        animateMiniPlayerView(type: .animateIn)
        minimizeEpisodeImage()
    }

    func maximizePlayerDetails(episode: Episode?) {
        if episode != nil {
            playerDetailsView.episode = episode
        }
        toggleTopAnchorConstraints(maximizingPlayer: true)
        animatePlayerControls(type: .animateIn)
        animateMiniPlayerView(type: .animateOut)
        maximizeEpisodeImage()
    }
    
    

    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - Setup
    
    let playerDetailsView = PlayerDetailsView()
    
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!

    fileprivate func setupPlayerDetailsView() {

        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
        // AUTO-LAYOUT
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        maximizedTopAnchorConstraint.isActive = true
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    
    let progressBar = UIView()
    fileprivate func setupProgressBar() {
        view.insertSubview(progressBar, belowSubview: tabBar)
        
        progressBar.backgroundColor = .red
        
        // AUTO-LAYOUT
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
        progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        progressBar.bottomAnchor.constraint(equalTo: playerDetailsView.topAnchor).isActive = true
    }
    
    // width  = percentage of duration played
    
    
    
    
    
    
    
    
    func toggleTopAnchorConstraints(maximizingPlayer: Bool) {
        maximizedTopAnchorConstraint.isActive = maximizingPlayer ? true : false
        minimizedTopAnchorConstraint.isActive = maximizingPlayer ? false : true
        if maximizingPlayer { maximizedTopAnchorConstraint.constant = 0 }
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func setupViewControllers() {
        viewControllers = [
            generateNavigationController(with: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            generateNavigationController(with: ViewController(), title: "Favourites", image: #imageLiteral(resourceName: "favorites")),
            generateNavigationController(with: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
    }
    
    //MARK: - Helper Functions
    
    fileprivate func generateNavigationController(with rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.topItem?.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}


