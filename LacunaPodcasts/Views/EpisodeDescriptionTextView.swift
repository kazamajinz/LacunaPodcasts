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
        
        // Text Attributes
        linkTextAttributes = [.foregroundColor: UIColor.orange ?? UIColor.white]

//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 10
//        let attributes : [NSAttributedString.Key: Any] =
//            [.paragraphStyle : paragraphStyle, .foregroundColor: UIColor.white]
//        attributedText = NSAttributedString(string: text, attributes: attributes)
        
        
        
        
    }
}
