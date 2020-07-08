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
        UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: nil, miniPlayerIsVisible: nil)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {

        let translation = gesture.translation(in: superview)
        let velocity = gesture.velocity(in: superview)

        switch gesture.state {
        case .changed:
//            var fraction = -transla tion.y / 500
//            if state == .maximized { fraction *= -1 }
//            animator.fractionComplete = fraction
            
            self.transform = CGAffineTransform(translationX: 0, y: translation.y / 5)

            print("Ended:", translation.y, velocity.y)
        case .ended:
            
            print("Ended:", translation.y)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = .identity
            })
            
            if abs(velocity.y) > 500 { // abs(translation.y) > 20 
                UIApplication.mainTabBarController()?.toggleState()
            }
        default:
            break
        }
    }
}

   
   
    

