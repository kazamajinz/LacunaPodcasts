//
//  UserDefaults.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-09.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func savedPodcasts() -> [Podcast] {
        guard let data = UserDefaults.standard.data(forKey: K.UserDefaults.savedPodcastKey) else { return [] }
        do {
            let savedPodcasts = try JSONDecoder().decode([Podcast].self, from: data)
            return savedPodcasts
        } catch let decodeErr { print("Failed to decode Saved Podcasts:", decodeErr) }
        return []
    }
    
//    func deletePodcast(podcast: Podcast) {
//        let podcasts = savedPodcasts()
//        let filteredPodcasts = podcasts.filter { (p) -> Bool in
//            return p.trackName != podcast.trackName && p.artistName != podcast.artistName
//        }
//        let data = NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts)
//        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
//    }
    
}
