//
//  UIViewController + Extensions.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-03.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    
    // MARK: - SFSafariViewController
    
    func showWebView(_ urlString: String) {
        if let url = URL(string: urlString) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = false
            config.barCollapsingEnabled = false
            let vc = SFSafariViewController(url: url, configuration: config)
            vc.modalPresentationStyle = .popover
            self.present(vc, animated: true)
        }
    }
}


