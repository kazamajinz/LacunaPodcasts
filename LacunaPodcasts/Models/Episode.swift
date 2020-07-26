//
//  Episode.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-06-30.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation
import FeedKit

enum DownloadStatus: String, Codable {
    case none
    case inProgress
    case completed
    case failed
    
    var titleColor: UIColor {
        switch self {
        case .completed: return UIColor.white
        default: return UIColor(named: K.Colors.grayBlue) ?? UIColor.white
        }
    }
    
    var descriptionColor: UIColor {
        switch self {
        case .completed: return UIColor(named: K.Colors.lightGray) ?? UIColor.white
        default: return UIColor(named: K.Colors.grayBlue) ?? UIColor.white
        }
    }
    
    var detailsColor: UIColor {
        switch self {
        case .none: return UIColor(named: K.Colors.grayBlue) ?? UIColor.white
        case .inProgress: return UIColor(named: K.Colors.orange) ?? UIColor.white
        case .completed: return UIColor(named: K.Colors.lightGray) ?? UIColor.white
        case .failed: return UIColor(named: K.Colors.grayBlue) ?? UIColor.white
        }
    }
}

struct Episode: Codable {
    let title: String
    let pubDate: Date
    let description: String
    let author: String
    let duration: Double
    let streamUrl: String
    
    let keywords: String
    
    var fileUrl: String?
    var imageUrl: String?

    var contentEncoded: String?
    
    var isDownloaded: Bool = false
    var downloadStatus: DownloadStatus = .none
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.description ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.duration = feedItem.iTunes?.iTunesDuration ?? 0
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        self.keywords = feedItem.iTunes?.iTunesKeywords ?? ""
        
        // HTML
        self.contentEncoded = feedItem.content?.contentEncoded ?? ""
    }
}
