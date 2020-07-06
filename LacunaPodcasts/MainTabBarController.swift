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
//        setupMiniDurationBar()
    }
    
    //MARK: - Animations
    
    var maximizeAnimator: UIViewPropertyAnimator!
    var minimizeAnimator: UIViewPropertyAnimator!
    
    var animationDuration: TimeInterval = 0.5
    var shortAnimationDuration: TimeInterval = 0.2
    var animationDelay: CGFloat {
        return CGFloat(animationDuration * 0.5)
    }
    
    private func setupMaximizeAnimator() {
        
        maximizeAnimator = UIViewPropertyAnimator(duration: animationDuration, dampingRatio: 1, animations: { [weak self] in
            
            guard let self = self else { return }
            
            // AUTO-LAYOUT
            self.minimizedTopAnchorConstraint.isActive = false
            self.maximizedTopAnchorConstraint.isActive = true
            self.maximizedTopAnchorConstraint.constant = 0
            self.bottomAnchorConstraint.constant = 0

            let episodeImageContainerWidth = self.playerDetailsView.episodeImageContainer.bounds.width
            
            self.playerDetailsView.maxiHeaderHeight.constant = 64
            self.playerDetailsView.episodeImageViewHeight.constant = episodeImageContainerWidth - 24 * 2
            self.playerDetailsView.episodeImageViewLeading.constant = 24
            self.playerDetailsView.episodeImageView.roundCorners(cornerRadius: 16)

            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            self.hideTabBar()
            
        })
        
        maximizeAnimator.startAnimation()
        
        // ANIMATE IN: Player Controls
        maximizeAnimator.addAnimations({ [weak self] in
            guard let self = self else { return }
            self.playerDetailsView.maxiHeader.alpha = 1
            self.playerDetailsView.playerControlsContainer.alpha = 1
        }, delayFactor: self.animationDelay)
        
        // ANIMATE OUT:  Mini Player
        maximizeAnimator.addAnimations({ [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: self.shortAnimationDuration, animations: {
                self.playerDetailsView.miniPlayerView.alpha = 0
            })
        })
        
        // ADD COMPLETION
        maximizeAnimator.addCompletion { [weak self] (position) in
            guard let self = self else { return }
            self.maximizeAnimator = nil
        }
    }
    
    private func setupMinimizeAnimator() {
        
        minimizeAnimator = UIViewPropertyAnimator(duration: animationDuration, dampingRatio: 1, animations: { [weak self] in
            
            guard let self = self else { return }
            
            self.maximizedTopAnchorConstraint.isActive = false
            self.bottomAnchorConstraint.constant = self.view.frame.height
            self.minimizedTopAnchorConstraint.isActive = true

            self.playerDetailsView.maxiHeaderHeight.constant = 0
            self.playerDetailsView.episodeImageViewHeight.constant = 64
            self.playerDetailsView.episodeImageViewLeading.constant = 0
            self.playerDetailsView.episodeImageView.roundCorners(cornerRadius: 0)
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            self.showTabBar()
            
        })
        
        minimizeAnimator.startAnimation()
        
        // ANIMATE OUT: Player Controls
        minimizeAnimator.addAnimations({ [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: self.shortAnimationDuration, animations: {
                self.playerDetailsView.maxiHeader.alpha = 0
                self.playerDetailsView.playerControlsContainer.alpha = 0
            })
        })
        
        // ANIMATE IN: Mini Player
        minimizeAnimator.addAnimations({ [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: self.shortAnimationDuration, animations: {
                self.playerDetailsView.miniPlayerView.alpha = 1
            })
            }, delayFactor: self.animationDelay + 0.2)
        
        // ADD COMPLETION
        minimizeAnimator.addCompletion { [weak self] (position) in
            guard let self = self else { return }
            self.minimizeAnimator = nil
        }
    }
    
    
    
    
    

    func maximizePlayerDetails(episode: Episode?) {
        if episode != nil {
            playerDetailsView.episode = episode
        }
        
        setupMaximizeAnimator()
    }
    
    
    
    
    
    
    
    
    
    @objc func minimizePlayerDetails() {
         setupMinimizeAnimator()
    }

    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - Setup
    
    let playerDetailsView = PlayerDetailsView()
    
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!

    fileprivate func setupPlayerDetailsView() {

        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
        // AUTO-LAYOUT
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        maximizedTopAnchorConstraint.isActive = true
        bottomAnchorConstraint = playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    
    
//
//    let miniDurationBar = UISlider()
//    fileprivate func setupMiniDurationBar() {
//
//        view.addSubview(miniDurationBar)
//        miniDurationBar.isUserInteractionEnabled = false
//        miniDurationBar.setThumbImage(UIImage(), for: .normal)
//        miniDurationBar.minimumTrackTintColor = .black
//        miniDurationBar.maximumTrackTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//
//        // AUTO-LAYOUT
//        miniDurationBar.translatesAutoresizingMaskIntoConstraints = false
//        miniDurationBar.bottomAnchor.constraint(equalTo: playerDetailsView.topAnchor).isActive = true
//        miniDurationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -2).isActive = true
//        miniDurationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2).isActive = true
//    }
//


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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


