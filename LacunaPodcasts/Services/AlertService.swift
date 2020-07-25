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
    
    public static func showActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = UIColor(named: K.Colors.highlight)
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    //MARK: - Action Sheet
    
    private static func showBasicActionSheetAlert(on vc: UIViewController, title: String, message: String, actionHandler: ((UIAlertAction) -> Void)?, cancelHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Yes", style: .destructive, handler: actionHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler)
        alert.addAction(action) ; alert.addAction(cancelAction)
        DispatchQueue.main.async { vc.present(alert, animated: true, completion: nil) }
    }
    
    static func showFileUrlNotFoundAlert(on vc: UIViewController, actionHandler: ((UIAlertAction) -> Void)?) {
        showBasicActionSheetAlert(on: vc, title: "Local file could not be found", message: "Would you like to stream the podcast instead?", actionHandler: actionHandler, cancelHandler: nil)
    }
    
}
