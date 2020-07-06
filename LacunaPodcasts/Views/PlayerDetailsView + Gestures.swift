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

        switch gesture.state {
        case .began:
            print("Pan Gesture Began")

            
            
//            episodeImageAnimator.pauseAnimation()
//            self.animationProgress = episodeImageAnimator.fractionComplete
//            self.dragStartPosition = gesture.location(in: self.superview)

        case .changed:
            print("Pan Gesture Changed")
            
            //episodeImageAnimator.pauseAnimation()

//            let translation = gesture.translation(in: self.superview)
//            print("Ended:", translation.y)
//
//            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
            
            
            
            //let delta = location.y - self.dragStartPosition.y
            
            //episodeImageAnimator.fractionComplete = max(0.0, min(1.0, self.animationProgress + delta / 300.0))
            
            
        case .ended:
            print("Pan Gesture Ended")
            
            
            //episodeImageAnimator.startAnimation()
        default:
            break
        }

    }
    
    
    
//    func handlePanChanged(gesture: UIPanGestureRecognizer) {
//
//
//
//        // SCREEN SIZES
////        let screenSizeHeight = UIScreen.main.bounds.height
////        let safeAreaTop = window?.safeAreaInsets.top ?? 0
////        let safeAreaBottom = window?.safeAreaInsets.bottom ?? 0
////        let screenHeight = screenSizeHeight - safeAreaTop - safeAreaBottom
//        //let maxImageWidth = episodeImageContainer.bounds.width - 24 * 2
//        //let inverseRatio = 1 - abs(translation.y / screenHeight)
//
//
//
//
//
//        let translation = gesture.translation(in: self.superview)
//        print("Ended:", translation.y)
//
//        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
//
//        let fraction = -translation.y / screenHeight
//
//
//        mainTabBarController.episodeImageAnimator.pauseAnimation()
//        let delta = translation.y
//
//
//
//    }
//
//
//    func handlePanEnded(gesture: UIPanGestureRecognizer) {
//        guard let mainTabBarController = UIWindow.key?.rootViewController as? MainTabBarController else { return }
//
//        let translation = gesture.translation(in: self.superview)
//        let velocity = gesture.velocity(in: self.superview)
//
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//
//            self.transform = .identity
//
//            if gesture.verticalDirection(target: self) == .up {
//                if translation.y < -80 || velocity.y < -500 {
//                    mainTabBarController.maximizePlayerDetails(episode: nil)
//                } else {
//                    mainTabBarController.minimizePlayerDetails()
//                }
//            } else if gesture.verticalDirection(target: self) == .down {
//                if translation.y > 80 || velocity.y > 500 {
//                    mainTabBarController.minimizePlayerDetails()
//                } else {
//                    mainTabBarController.maximizePlayerDetails(episode: nil)
//                }
//            }
//        }, completion: nil)
//    }
    
}



