//
//  String + Extensions.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-06-30.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

extension String {

    func stripOutHtml() -> String? {
        do {
            guard let data = self.data(using: .unicode) else {
                return nil
            }
            let attributed = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributed.string
        } catch {
            return nil
        }
    }
    
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
    
    func collapseText(to indexDistance: IndexDistance) -> String {
        if let index = self.index(self.startIndex, offsetBy: indexDistance, limitedBy: self.endIndex) {
            return String(self[...index] + "... more")
        } else { return "" }
    }
    
    
    //MARK: - HTML
    
    func convertHtml(family: String?, size: CGFloat, csscolor: String) -> NSAttributedString? {
        
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(size)pt !important;" +
                "font-family: \(family ?? "Helvetica"), Helvetica !important;" +
                "line-height: 1.5;" +
                "color: \(csscolor);" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else { return nil }
                
                return try NSAttributedString(data: data,
                                              options: [.documentType: NSAttributedString.DocumentType.html,
                                                        .characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)], documentAttributes: nil)
            } catch {
                print("Failed to convert HTML to attributed string:", error.localizedDescription)
                return nil
            }
        }
}
