//
//  UIApplication + Extensions.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-06.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static func mainTabBarController() -> MainTabBarController? {
        return UIWindow.key?.rootViewController as? MainTabBarController
    }
    
    static func mainNavigationController() -> MainNavigationController? {
        return UIWindow.key?.rootViewController as? MainNavigationController
    }
    
}
