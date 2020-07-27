//
//  EpisodeDescriptionTextView.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-12.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class EpisodeDescriptionTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupTextView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextView()
    }
    
    private func setupTextView() {
        textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 16)
        linkTextAttributes = [.foregroundColor: UIColor.appColor(.orange) ?? UIColor.white]
        
        
        
        
//        
//        guard let podcast = self?.selectedPodcast else { return }
//        guard let url = URL(string: podcast.link ?? "") else { return }
//        let config = SFSafariViewController.Configuration()
//        config.entersReaderIfAvailable = false
//        config.barCollapsingEnabled = false
//        let vc = SFSafariViewController(url: url, configuration: config)
//        vc.modalPresentationStyle = .popover
//        self?.present(vc, animated: true, completion: nil)

//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 10
//        let attributes : [NSAttributedString.Key: Any] =
//            [.paragraphStyle : paragraphStyle, .foregroundColor: UIColor.white]
//        attributedText = NSAttributedString(string: text, attributes: attributes)
        
        
        
        
    }
}
