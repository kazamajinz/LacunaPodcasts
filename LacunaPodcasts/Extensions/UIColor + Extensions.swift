//
//  UIColor + Extensions.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-13.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

enum AssetsColor: String {
    case midnight // background
    case highlight
    case blue
    case darkBlue // selected episode cell
    case grayBlue // inactive episode cell
    case orange
    case lightGray // active episode cell + subtitles
    //case darkGray
}



extension UIColor {
    
    static func appColor(_ name: AssetsColor) -> UIColor? {
        let colorName = name.rawValue
        return UIColor(named: colorName)
    }
    
    
//    static let darkBlue = UIColor(named: "darkBlue")
//    static let blue = UIColor(named: "blue")
//    static let highlight = UIColor(named: "highlight")
//    static let orange = UIColor(named: "orange")
//    static let midnight = UIColor(named: "midnight")
//    static let grayBlue = UIColor(named: "grayBlue")
//    static let lightGray = UIColor(named: "lightGray")
//    static let green = UIColor(named: "green")
    
    
    
    
    
    
    
    
    
    // MARK: - Flyweight
    
    public static var colorStore: [String: UIColor] = [:]
    
//    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
//        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
//    }
    
    public class func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat) -> UIColor {
        let key = "\(r)\(g)\(b)\(alpha)"
        if let color = colorStore[key] {
            return color
        }
        let color = UIColor(red: r, green: g, blue: b, alpha: alpha)
        colorStore[key] = color
        return color
    }
    
    // MARK: - HEX to UIColor

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
