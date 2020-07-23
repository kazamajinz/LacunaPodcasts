//
//  FollowButton.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-08.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class FollowButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    fileprivate func setupButton() {
        
        //addTarget(self, action: #selector(handlePress), for: .allTouchEvents)
        
        backgroundColor = .clear
        transform = .identity
        
        // Text
        setTitle("FOLLOW", for: .normal)
        setTitle("FOLLOWING", for: .selected)
        
        setTitleColor(.white, for: .normal)
        setTitleColor(.white, for: .highlighted)
        setTitleColor(.white, for: .selected)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        
        // Border
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = self.frame.size.height / 2
        
    }
    
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let width = originalContentSize.width + 36
        let height = originalContentSize.height + 12
        layer.cornerRadius = height / 2
        layer.masksToBounds = true
        return CGSize(width: width, height: height)
    }
    
    override var isSelected: Bool {
        didSet {
            layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.lightGray.cgColor
            backgroundColor = isSelected ? UIColor(named: K.Colors.orange) : UIColor.clear
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            isSelected ? setTitle("FOLLOWING", for: .highlighted) : setTitle("FOLLOW", for: .highlighted)
            transform =  isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
        }
    }
    
}
