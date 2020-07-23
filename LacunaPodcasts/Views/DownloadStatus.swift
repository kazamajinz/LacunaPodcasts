//
//  DownloadStatusButton.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-23.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class DownloadStatus: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        let shapeLayer = CAShapeLayer()
        let center = self.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 10, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        self.layer.addSublayer(shapeLayer)
    }
    
}
