//
//  UISearchBar + Extensions.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-25.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    var textField: UITextField? {
        if #available(iOS 13, *) {
            return searchTextField
        }
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }
    
}
