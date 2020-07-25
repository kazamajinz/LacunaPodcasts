//
//  UIColor + Extensions.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-13.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let darkBlue = UIColor(named: K.Colors.darkBlue)
    static let blue = UIColor(named: K.Colors.blue)
    static let highlight = UIColor(named: K.Colors.highlight)
    static let orange = UIColor(named: K.Colors.orange)
    static let midnight = UIColor(named: K.Colors.midnight)
    static let grayBlue = UIColor(named: K.Colors.grayBlue)
    static let lightGray = UIColor(named: K.Colors.lightGray)
    static let green = UIColor(named: K.Colors.green)
    
    
    
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }

    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}
