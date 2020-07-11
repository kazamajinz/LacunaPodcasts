//
//  Download.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-10.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation
import Alamofire

class Download {
    
    var isDownloading = false
    var progress: Double = 0.0
    var resumeData: Data?
    var task: DownloadRequest?
    var episode: Episode
    
    // The episode’s url property also acts as a unique identifier for Download
    
    init(episode: Episode) {
      self.episode = episode
    }
    
}
