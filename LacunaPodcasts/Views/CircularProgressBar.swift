//
//  DownloadStatusButton.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-23.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class CircularProgressBar: UIView {
    
    private var progressLayer: CAShapeLayer!
    private var trackLayer: CAShapeLayer!
    private var pulsatingLayer: CAShapeLayer!
    private var lineWidth: CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupObservers()
    }

    private func setupView() {
        self.layer.sublayers = nil
        //drawPulsatingLayer()
        drawTrackLayer()
        drawProgressLayer()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func handleEnterForeground() {
        //animatePulsatingLayer()
    }
    
    private func createCircleShapeLayer(startAngle: CGFloat, endAngle: CGFloat, strokeColor: UIColor, fillColor: UIColor, lineWidth: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(arcCenter: .zero, radius: 14, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = lineWidth
        layer.fillColor = fillColor.cgColor
        layer.lineCap = .round
        layer.position = self.center
        return layer
    }
    
    private func drawPulsatingLayer() {
        let startAngle = CGFloat(0)
        let endAngle = 2 * CGFloat.pi
        pulsatingLayer = createCircleShapeLayer(startAngle: startAngle, endAngle: endAngle, strokeColor: UIColor.appColor(.blue) ?? UIColor.clear, fillColor: .clear, lineWidth: 4)
        layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
    }
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.1
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulse")
    }
    
    private func drawTrackLayer() {
        let startAngle = CGFloat(0)
        let endAngle = 2 * CGFloat.pi
        trackLayer = createCircleShapeLayer(startAngle: startAngle, endAngle: endAngle, strokeColor: UIColor.appColor(.blue) ?? UIColor(), fillColor: .clear, lineWidth: lineWidth)
        layer.addSublayer(trackLayer)
    }

    private func drawProgressLayer() {
        let startAngle = -CGFloat.pi/2
        let endAngle = 2 * CGFloat.pi + startAngle
        progressLayer = createCircleShapeLayer(startAngle: startAngle, endAngle: endAngle, strokeColor: UIColor.appColor(.orange) ?? UIColor(), fillColor: .clear, lineWidth: lineWidth)
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
    }
    
    public func setProgress(to progress: Double) {
        progressLayer.strokeEnd = CGFloat(progress)
    }

}
