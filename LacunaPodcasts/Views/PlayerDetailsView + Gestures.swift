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

        guard let mainTabBarController = UIWindow.key?.rootViewController as? MainTabBarController else { return }
        let animator = mainTabBarController.animator
        let state = mainTabBarController.state

        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)

        switch gesture.state {
        case .began:
            
            mainTabBarController.toggleState()
            animator.pauseAnimation()
            
        case .changed:
            
            var fraction = -translation.y / 500
            if state == .maximized { fraction *= -1 }
            animator.fractionComplete = fraction
            
            //print("Ended:", translation.y, velocity.y)
            
        case .ended:
            
            print("GESTURE ENDED")
            
            if abs(translation.y) > 10 || abs(velocity.y) > 500 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            } else {
                animator.isReversed = true
            }

            

        default:
            break
        }
    }
}

   
   
    

