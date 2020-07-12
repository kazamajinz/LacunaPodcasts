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
        //font = .systemFont(ofSize: 24)
        textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
