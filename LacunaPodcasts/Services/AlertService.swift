//
//  AlertService.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-03.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class AlertService {
    private init() {}
    
    public static func showActivityIndicator(completionHandler: (UIActivityIndicatorView) -> Void) -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        completionHandler(activityIndicatorView)
        return activityIndicatorView
    }
    
}
