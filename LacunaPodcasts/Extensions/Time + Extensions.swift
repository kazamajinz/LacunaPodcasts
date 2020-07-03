//
//  TimeInterval + Extensions.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-01.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation
import AVKit

extension TimeInterval {
    func convertToEpisodeDurationString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        return formatter.string(from: self) ?? ""
    }
}

extension CMTime {
    func toDisplayString() -> String {
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds / 60) % 60
        let seconds = totalSeconds % 60
        if totalSeconds < 3600 {
            return "-" + String(format: "%02d:%02d", minutes, seconds)
        } else {
            return "-" + String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
}





extension Double {
    func toDisplayString() -> String {
        let totalSeconds = Int(self)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds / 60) % 60
        let seconds = totalSeconds % 60
        if totalSeconds < 3600 {
            return "-" + String(format: "%02d:%02d", minutes, seconds)
        } else {
            return "-" + String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
}
