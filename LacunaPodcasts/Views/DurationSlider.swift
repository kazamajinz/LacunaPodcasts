//
//  DurationSlider.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-05.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class DurationSlider: UISlider {

    @IBInspectable var trackHeight: CGFloat = 4
    @IBInspectable var thumbRadius: CGFloat = 14
    @IBInspectable var thumbSelectedRadius: CGFloat = 16

    // Custom thumb view which will be converted to UIImage
    // and set as thumb. You can customize it's colors, border, etc.
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        thumb.backgroundColor = .black//thumbTintColor
        //thumb.layer.borderWidth = 1
        //thumb.layer.borderColor = UIColor.white.cgColor
        return thumb
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        let thumb = thumbImage(diameter: thumbRadius)
        let thumbSelected = thumbImage(diameter: thumbSelectedRadius)
        setThumbImage(UIImage(), for: .normal)
        setThumbImage(thumb, for: .normal)
        setThumbImage(thumbSelected, for: .selected)
        setThumbImage(thumbSelected, for: .highlighted)
    }
    
    private func thumbImage(diameter: CGFloat) -> UIImage {
        // Set proper frame
        // y: diameter / 2 will correctly offset the thumb

        thumbView.frame = CGRect(x: 0, y: diameter / 2, width: diameter, height: diameter)
        thumbView.layer.cornerRadius = diameter / 2

        // Convert thumbView to UIImage
        // See this: https://stackoverflow.com/a/41288197/7235585

        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Set custom track height
        // As seen here: https://stackoverflow.com/a/49428606/7235585
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }

}
