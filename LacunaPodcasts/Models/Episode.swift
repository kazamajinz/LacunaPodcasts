//
//  Episode.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-06-30.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation
import FeedKit

struct Episode {
    
    let title: String
    let pubDate: Date
    let description: String
    let author: String
    let streamUrl: String
    let duration: Double
    
    var imageUrl: String?
    
    init(feedItem: RSSFeedItem) {
        
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.description ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.duration = feedItem.iTunes?.iTunesDuration ?? 0
        
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
    }
}
