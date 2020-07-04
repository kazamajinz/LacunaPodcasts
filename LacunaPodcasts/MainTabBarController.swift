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
    }
    
    @objc func minimizePlayerDetails() {
        
        maximizedTopAnchorConstraint.isActive = false
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.playerDetailsView.maximizedHeader.alpha = 0
            self.playerDetailsView.durationSliderContainer.alpha = 0
            self.playerDetailsView.playerControlsContainer.alpha = 0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.1, delay: 0.4, options: .curveEaseOut, animations: {
            self.playerDetailsView.miniPlayerView.alpha = 1
        }, completion: nil)
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {

            self.playerDetailsView.maximizedHeaderHeight.constant = 0
            
            
            // configure episode image
            self.playerDetailsView.episodeImageView.roundCorners(cornerRadius: 0)
            self.playerDetailsView.episodeImageViewHeight.constant = 64
            self.playerDetailsView.episodeImageViewTop.constant = 0
            self.playerDetailsView.episodeImageViewLeading.constant = 0
            self.playerDetailsView.episodeImageViewBottom.constant = 0
            
            self.view.layoutIfNeeded()
            self.showTabBar()
            
        }, completion: nil)
        
        
        
        
        
    }
    
    
    func maximizePlayerDetails(episode: Episode?) {
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        minimizedTopAnchorConstraint.isActive = false
        
        if episode != nil {
            playerDetailsView.episode = episode
        }
        
        self.playerDetailsView.miniPlayerView.alpha = 0
        
        UIView.animate(withDuration: 0.1, delay: 0.4, options: .curveEaseOut, animations: {
            self.playerDetailsView.maximizedHeader.alpha = 1
            self.playerDetailsView.durationSliderContainer.alpha = 1
            self.playerDetailsView.playerControlsContainer.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
           
            self.playerDetailsView.maximizedHeaderHeight.constant = 52
            
            self.playerDetailsView.episodeImageView.roundCorners(cornerRadius: 16)
            self.playerDetailsView.episodeImageViewHeight.constant = self.playerDetailsView.episodeImageContainer.bounds.width - 24 * 2
            self.playerDetailsView.episodeImageViewTop.constant = 0
            self.playerDetailsView.episodeImageViewBottom.constant = 0
            self.playerDetailsView.episodeImageViewLeading.constant = 24
            
            self.playerDetailsView.playerControlsContainer.transform = .identity
            
            
            
            
            self.view.layoutIfNeeded()
            self.hideTabBar()
            
        }, completion: nil)
    }
    
    

    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - Setup
    
    let playerDetailsView = PlayerDetailsView()
    
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    
    var minimizedBottomAnchorConstraint: NSLayoutConstraint!

    fileprivate func setupPlayerDetailsView() {

        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
        // AUTO-LAYOUT
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        
        
        
        
        
    
        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)

        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func setupViewControllers() {
        viewControllers = [
            generateNavigationController(with: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            generateNavigationController(with: ViewController(), title: "Favourites", image: #imageLiteral(resourceName: "favorites")),
            generateNavigationController(with: ViewController(),    title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
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
