//
//  UIWindow + Extensions.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-03.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
