//
//  UIViewController + Extensions.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-03.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    func hideTabBar() {
        self.tabBar.frame.origin.y = self.view.frame.size.height + (self.tabBar.frame.size.height)
        //UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut ,animations: {
            self.tabBar.frame = self.tabBar.frame
        //})
    }
    
    func showTabBar() {
        self.tabBar.frame.origin.y = self.view.frame.size.height - (self.tabBar.frame.size.height)
        //UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut ,animations: {
            self.tabBar.frame = self.tabBar.frame
        //})
    }

}


