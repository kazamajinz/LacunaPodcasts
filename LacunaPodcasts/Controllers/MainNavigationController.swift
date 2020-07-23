//
//  MainNavigationController.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-23.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let minimizePlayerDetails = NSNotification.Name("minimizePlayerDetails")
}

enum State {
    case maximized, minimized
    var change: State {
        switch self {
        case .maximized: return .minimized
        case .minimized: return .maximized
        }
    }
}

class MainNavigationController: UINavigationController {
    
    // MARK: - Variables and Properties
    
    let playerDetailsView = PlayerDetailsView()
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerDetailsView()
    }
    
    //MARK: - Setup

    fileprivate func setupPlayerDetailsView() {
        view.addSubview(playerDetailsView)
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height + 2)
        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64)
        maximizedTopAnchorConstraint.isActive = true
        bottomAnchorConstraint = playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    //MARK: - Animations
    
    func toggleState() {
        switch state {
        case .minimized: maximize()
        case .maximized: minimize()
        }
    }
    
    var miniPlayerIsVisible = false
    var state: State = .minimized
    
    lazy var animator: UIViewPropertyAnimator = {
        return UIViewPropertyAnimator(duration: animationDuration, dampingRatio: 1)
    }()
    
    private var animationDuration: TimeInterval = 0.5
    private var shortAnimationDuration: TimeInterval {
        return animationDuration * 0.05
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
            self.playerDetailsView.episodeImageContainerHeight.constant = episodeImageContainerWidth - 36 * 2
            self.playerDetailsView.episodeDescriptionTextViewLeading.constant = 36
            self.playerDetailsView.episodeDescriptionTextViewContainer.roundCorners(cornerRadius: 16)
            self.playerDetailsView.episodeImageViewLeading.constant = 36
            self.playerDetailsView.episodeImageViewTop.constant = 0
            self.playerDetailsView.episodeImageViewBottom.constant = 0
            self.playerDetailsView.episodeImageView.roundCorners(cornerRadius: 16)
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
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
                self.playerDetailsView.miniProgressBar.alpha = 0
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
            self.playerDetailsView.episodeImageContainerHeight.constant = 64
            self.playerDetailsView.episodeDescriptionTextViewLeading.constant = 0
            self.playerDetailsView.episodeDescriptionTextViewContainer.roundCorners(cornerRadius: 0)
            self.playerDetailsView.episodeImageViewTop.constant = 8
            self.playerDetailsView.episodeImageViewLeading.constant = 8
            self.playerDetailsView.episodeImageViewBottom.constant = 8
            self.playerDetailsView.episodeImageView.roundCorners(cornerRadius: 4)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        
        // ANIMATE OUT: Player Controls -- THIS NEEDS TO FADE OUT SOONER
        animator.addAnimations({ [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: self.shortAnimationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.playerDetailsView.maxiHeader.alpha = 0
                self.playerDetailsView.playerControlsContainer.alpha = 0
                self.playerDetailsView.episodeDescriptionTextViewContainer.alpha = 0
            })
        })
        
        // ANIMATE IN: Mini Player
        animator.addAnimations({ [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: self.shortAnimationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.playerDetailsView.miniPlayerView.alpha = 1
                self.playerDetailsView.miniProgressBar.alpha = 1
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
    
    
    
    
    
    
    
    
    func maximizePlayerDetails(episode: Episode?, playlistEpisodes: [Episode] = []) {
        if episode != nil { playerDetailsView.episode = episode }
        playerDetailsView.playlistEpisodes = playlistEpisodes
        
        miniPlayerIsVisible = true
        
        maximize()
    }
    
    @objc func minimizePlayerDetails() {
        minimize()
        NotificationCenter.default.post(name: .minimizePlayerDetails, object: nil, userInfo: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

