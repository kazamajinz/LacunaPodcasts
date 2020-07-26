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
        case .completed: return .white
        default: return .grayBlue ?? .white
        }
    }
    
    var descriptionColor: UIColor {
        switch self {
        case .completed: return .lightGray ?? .white
        default: return .grayBlue ?? .white
        }
    }
    
    var detailsColor: UIColor {
        switch self {
        case .none: return .grayBlue ?? .white
        case .inProgress: return .orange ?? .white
        case .completed: return .lightGray ?? .white
        case .failed: return .grayBlue ?? .white
        }
    }
}

struct Episode: Codable {
    
    var podcastCollectionId: Int = 0

    let title: String
    let pubDate: Date
    let description: String
    let author: String
    let duration: Double
    let streamUrl: String
    let keywords: String
    
    //var guid: RSSFeedItemGUID
    
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
        
        //self.guid = feedItem.guid ?? RSSFeedItemGUID.init()
        
        // HTML
        self.contentEncoded = feedItem.content?.contentEncoded ?? ""
    }
}
