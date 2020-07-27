//
//  BrowsePodcastsButton.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-27.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class BrowsePodcastsButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    fileprivate func setupButton() {
        backgroundColor = UIColor.appColor(.orange)
        transform = .identity
        setTitle("BROWSE PODCASTS", for: .normal)
        setTitleColor(UIColor.appColor(.midnight), for: .normal)
        setTitleColor(UIColor.appColor(.midnight), for: .selected)
        setTitleColor(UIColor.appColor(.midnight), for: .highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        layer.cornerRadius = self.frame.size.height / 2
    }
    
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let width = originalContentSize.width + 72
        let height = originalContentSize.height + 24
        layer.cornerRadius = height / 2
        layer.masksToBounds = true
        return CGSize(width: width, height: height)
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.appColor(.burntOrange) : UIColor.appColor(.orange)
            transform =  isHighlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
        }
    }
    
}

