//
//  SubscribedPodcasts.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-09.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation
import RealmSwift

class PodcastSubscriptions: Object {
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
//    @objc dynamic var id = UUID().uuidString
    
    @objc dynamic var id = "subscribedPodcasts"
    
    
    
    
    let podcasts = List<Podcast>()
    
    

    
}
