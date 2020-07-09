//
//  UserDefaults.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-09.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    //MARK: - Episodes
    
    func fetchDownloadedEpisodes() -> [Episode] {
        guard let data = UserDefaults.standard.data(forKey: K.UserDefaults.downloadedEpisodeKey) else { return [] }
        do {
            let downloadedEpisodes = try JSONDecoder().decode([Episode].self, from: data)
            return downloadedEpisodes
        } catch let decodeErr { print("Failed to decode downloaded episodes:", decodeErr) }
        return []
    }
    
    func downloadEpisode(episode: Episode) {
        
        // check to see if episode is already saved
        var downloadedEpisodes = fetchDownloadedEpisodes()
        
        if !downloadedEpisodes.contains(where: {$0.collectionId == episode.collectionId && $0.title == episode.title }) {
            // insert episode at the front of the list
            downloadedEpisodes.insert(episode, at: 0)
        }

        // ENCODE
        do {
            let data = try JSONEncoder().encode(downloadedEpisodes)
            UserDefaults.standard.set(data, forKey: K.UserDefaults.downloadedEpisodeKey)
        } catch let encodeErr { print("Failed to encode downloaded episode:", encodeErr) }
    }
    
    func deleteEpisode(episode: Episode) {
        let episodes = fetchDownloadedEpisodes()
        let filteredEpisodes = episodes.filter { (e) -> Bool in
            return e.title != episode.title || (e.title == episode.title && e.collectionId != episode.collectionId)
        }
        
        // ENCODE
        do {
            let data = try JSONEncoder().encode(filteredEpisodes)
            UserDefaults.standard.set(data, forKey: K.UserDefaults.downloadedEpisodeKey)
        } catch let encodeErr { print("Failed to delete Episode:", encodeErr) }
    }
    
    
    
    //MARK: - Podcasts
    
    func fetchSavedPodcasts() -> [Podcast] {
        guard let data = UserDefaults.standard.data(forKey: K.UserDefaults.savedPodcastKey) else { return [] }
        do {
            let savedPodcasts = try JSONDecoder().decode([Podcast].self, from: data)
            return savedPodcasts
        } catch let decodeErr { print("Failed to decode Saved Podcasts:", decodeErr) }
        return []
    }
    
    func deletePodcast(podcast: Podcast) {
        let podcasts = fetchSavedPodcasts()
        let filteredPodcasts = podcasts.filter { (p) -> Bool in
            return p.collectionId != podcast.collectionId
        }
        
        // ENCODE
        do {
            let data = try JSONEncoder().encode(filteredPodcasts)
            UserDefaults.standard.set(data, forKey: K.UserDefaults.savedPodcastKey)
        } catch let encodeErr { print("Failed to delete Podcast:", encodeErr) }
    }
    
    func savePodcast(podcast: Podcast) {
        
        // check to see if podcast is already saved
        var savedPodcasts = fetchSavedPodcasts()
        
        if savedPodcasts.contains(where: { $0.collectionId == podcast.collectionId }) {
            deletePodcast(podcast: podcast)
        } else {
            savedPodcasts.append(podcast)
            
            // ENCODE
            do {
                let data = try JSONEncoder().encode(savedPodcasts)
                UserDefaults.standard.set(data, forKey: K.UserDefaults.savedPodcastKey)
            } catch let encodeErr { print("Failed to encode Saved Podcasts:", encodeErr) }
        }
    }
    
    
    
    

    
}
