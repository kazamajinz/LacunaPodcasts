//
//  DownloadStatusButton.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-23.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class CircularProgressBar: UIView {
    
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    private var pathCenter: CGPoint { self.center }
    private var radius: CGFloat { 14 }
    private var lineWidth: CGFloat { 2 }
    private var pulsatingLayer: CAShapeLayer!
    
    var action: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        self.layer.sublayers = nil
        backgroundColor = .red
        drawPulsatingLayer()
        drawTrackLayer()
        drawProgressLayer()
    }
    
    private func drawPulsatingLayer() {
        pulsatingLayer = CAShapeLayer()
        let path = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        pulsatingLayer.path = path.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = lineWidth
        pulsatingLayer.fillColor = UIColor(named: K.Colors.darkBlue)?.cgColor
        pulsatingLayer.position = self.center
        layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.2
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulse")
    }
    
    private func drawTrackLayer() {
        let path = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = path.cgPath
        trackLayer.strokeColor = UIColor(named: K.Colors.highlight)?.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.fillColor = UIColor(named: K.Colors.midnight)?.cgColor
        trackLayer.position = self.center
        layer.addSublayer(trackLayer)
    }
    
    private func drawProgressLayer() {
        let startAngle = -CGFloat.pi/2
        let endAngle = 2 * CGFloat.pi + startAngle
        let path = UIBezierPath(arcCenter: pathCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressLayer.path = path.cgPath
        progressLayer.lineCap = .round
        progressLayer.strokeColor = UIColor(named: K.Colors.orange)?.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.strokeEnd = 0
        progressLayer.position = self.center
        layer.addSublayer(progressLayer)
    }
    
    public func setProgress(to progress: Double) {
        progressLayer.strokeEnd = CGFloat(progress)
    }
    
//    private func animateCircle() {
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.toValue = 1
//        animation.duration = 2
//        animation.fillMode = .forwards
//        animation.isRemovedOnCompletion = false
//        progressLayer.add(animation, forKey: "animation")
//    }

}



