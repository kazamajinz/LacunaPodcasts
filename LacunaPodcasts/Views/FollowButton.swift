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
        setTitleColor(.black, for: .normal)
        setTitleColor(.black, for: .highlighted)
        setTitleColor(.black, for: .selected)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 12.0, bottom: 8.0, right: 12.0)
        
        // Border
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = self.frame.size.height / 8
        
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .black : .clear
            setTitle("FOLLOWING", for: .normal)
            setTitle("FOLLOWING", for: .highlighted)
            setTitle("FOLLOWING", for: .selected)
        }
    }
    
    
    override var isHighlighted: Bool {
        didSet {
            layer.borderColor = isHighlighted ? UIColor.lightGray.cgColor : UIColor.black.cgColor
            transform =  isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
        }
    }
    
}
