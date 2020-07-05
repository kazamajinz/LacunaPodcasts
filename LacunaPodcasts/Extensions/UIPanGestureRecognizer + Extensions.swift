//
//  UIPanGestureRecognizer + Extensions.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-05.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

extension UIPanGestureRecognizer {
    
    enum GestureDirection {
        case up
        case down
    }
    
    func verticalDirection(target: UIView) -> GestureDirection {
        let detectionLimit: CGFloat = 0
        let panVelocity : CGPoint = velocity(in: target)
        return panVelocity.y > detectionLimit ? .down : .up
    }
}
