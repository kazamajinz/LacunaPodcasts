//
//  MainTabBarController.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-06-28.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

enum State {
    case maximized
    case minimized
    
    var change: State {
        switch self {
        case .maximized: return .minimized
        case .minimized: return .maximized
        }
    }
}

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
    
    func toggleState() {
        switch state {
        case .minimized: maximize()
        case .maximized: minimize()
        }
    }
    
    var state: State = .minimized

    lazy var animator: UIViewPropertyAnimator = {
        return UIViewPropertyAnimator(duration: animationDuration, dampingRatio: 1)
    }()
    
    private var animationDuration: TimeInterval = 0.5
    private var shortAnimationDuration: TimeInterval {
        return animationDuration * 0.01
    }
    private var animationDelay: CGFloat = 0.5

    func maximize() {

        animator.addAnimations { [weak self] in
            
            guard let self = self else { return }
            
            // AUTO-LAYOUT
            self.minimizedTopAnchorConstraint.isActive = false
            self.maximizedTopAnchorConstraint.isActive = true
            self.maximizedTopAnchorConstraint.constant = 0
            self.bottomAnchorConstraint.constant = 0

            let episodeImageContainerWidth = self.playerDetailsView.episodeImageContainer.bounds.width
            
            self.playerDetailsView.maxiHeaderHeight.constant = 64
            self.playerDetailsView.episodeImageViewHeight.constant = episodeImageContainerWidth - 36 * 2
            self.playerDetailsView.episodeImageViewLeading.constant = 36
            self.playerDetailsView.episodeImageView.roundCorners(cornerRadius: 16)
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            self.hideTabBar()
        }

        // ANIMATE IN: Player Controls
        animator.addAnimations({ [weak self] in
            guard let self = self else { return }
            self.playerDetailsView.maxiHeader.alpha = 1
            self.playerDetailsView.playerControlsContainer.alpha = 1
        }, delayFactor: self.animationDelay)
        
        // ANIMATE OUT:  Mini Player - THIS NEEDS TO FADE OUT SOONER!!!!!
        animator.addAnimations({ [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: self.shortAnimationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.playerDetailsView.miniPlayerView.alpha = 0
            })
        })
        
        // ADD COMPLETION
        animator.addCompletion { [weak self] (position) in
            guard let self = self else { return }
            self.state = self.state.change
            print("state:", self.state)
        }
        animator.startAnimation()        
    }
    
    func minimize() {
        
        animator.addAnimations { [weak self] in
            
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
        }
        
        // ANIMATE OUT: Player Controls -- THIS NEEDS TO FADE OUT SOONER
        animator.addAnimations({ [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: self.shortAnimationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.playerDetailsView.maxiHeader.alpha = 0
                self.playerDetailsView.playerControlsContainer.alpha = 0
            })
        })
        
        // ANIMATE IN: Mini Player - - THIS NEEDS TO FADE OUT SOONER
        animator.addAnimations({ [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: self.shortAnimationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.playerDetailsView.miniPlayerView.alpha = 1
            })
            }, delayFactor: self.animationDelay)
        
        // ADD COMPLETION
        animator.addCompletion { [weak self] (position) in
            guard let self = self else { return }
            self.state = self.state.change
            print("state:", self.state)
        }
        animator.startAnimation()
    }
    
    
    
    
    
    
    
    

    func maximizePlayerDetails(episode: Episode?) {
        if episode != nil {
            playerDetailsView.episode = episode
        }
        maximize()
    }
    
    
    
    
    
    
    


    @objc func minimizePlayerDetails() {
        minimize()
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


