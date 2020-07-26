//
//  Podcast.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-06-28.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation

struct Podcast: Codable, Equatable {
    
    var collectionId: Int?
    
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
    
    
    

    
    var description: String?
    var link: String?
    //var categories: Set<String>?
    
    
    
}





//    private enum CodingKeys: String, CodingKey {
//        case podcastDescription = "description"
//        case trackName, artistName, artworkUrl600, trackCount, feedUrl
//    }
