//
//  PlayerDetailsView + Gestures.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-05.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

extension PlayerDetailsView {
    
    @objc func handleTapMaximize() {
        guard let mainTabBarController = UIWindow.key?.rootViewController as? MainTabBarController else { return }
        mainTabBarController.maximizePlayerDetails(episode: nil)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            handlePanChanged(gesture: gesture)
        } else if gesture.state == .ended {
            handlePanEnded(gesture: gesture)
        }
    }

    func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let screenSizeHeight = UIScreen.main.bounds.height
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        print("Ended:", translation.y, velocity.y, screenSizeHeight)

        self.transform = CGAffineTransform(translationX: 0, y: translation.y)

        if gesture.verticalDirection(target: self) == .up {
            
            self.miniPlayerView.alpha = 1 + translation.y / (screenSizeHeight * 0.25)
            self.maxiHeaderHeight.constant = 64 * -(translation.y / screenSizeHeight)
            self.maxiHeader.alpha = -translation.y / (screenSizeHeight * 0.25)
            self.playerControlsContainer.alpha = (-translation.y - 500) / (screenSizeHeight * 0.25)

            // EPISODE IMAGE VIEW ANIMATION
            let maxImageWidth = episodeImageContainer.bounds.width - 24 * 2
            self.episodeImageViewLeading.constant = 24 * -(translation.y / screenSizeHeight)
            self.episodeImageViewHeight.constant = 64 +  (maxImageWidth * -(translation.y / screenSizeHeight))
            self.episodeImageView.roundCorners(cornerRadius: 16 * -(translation.y / screenSizeHeight))
            
        } else {
            
            
            
            print("Gesture Down")
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.transform = .identity
            
            
            
            if translation.y < -80 || velocity.y < -500 {
                guard let mainTabBarController = UIWindow.key?.rootViewController as? MainTabBarController else { return }
                mainTabBarController.maximizePlayerDetails(episode: nil)
            } else {
                guard let mainTabBarController = UIWindow.key?.rootViewController as? MainTabBarController else { return }
                mainTabBarController.minimizePlayerDetails()
            }
            
            
            
            
            
        }, completion: nil)
    }
    
}
