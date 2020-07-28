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
        guard let episodesData = data(forKey: K.UserDefaults.downloadedEpisodesKey) else { return [] }
        do {
            let episodes = try JSONDecoder().decode([Episode].self, from: episodesData)
            return episodes
        } catch { print("Failed to decode downloaded episodes:", error) }
        return []
    }
    
    func downloadEpisode(episode: Episode) {
        var episodes = fetchDownloadedEpisodes()
        if !episodes.contains(where: {$0.fileUrl == episode.fileUrl && $0.title == episode.title }) {
            episodes.insert(episode, at: 0)
        }
        do {
            let data = try JSONEncoder().encode(episodes)
            UserDefaults.standard.set(data, forKey: K.UserDefaults.downloadedEpisodesKey)
        } catch { print("Failed to encode downloaded episode:", error) }
    }
    
    func updateEpisode(episode: Episode, fileUrl: String?, downloadStatus: DownloadStatus) {
        var downloadedEpisodes = UserDefaults.standard.fetchDownloadedEpisodes()
        guard let index = downloadedEpisodes.firstIndex(where: {$0.title == episode.title && $0.streamUrl == episode.streamUrl} ) else { return }
        downloadedEpisodes[index].fileUrl = fileUrl
        downloadedEpisodes[index].downloadStatus = downloadStatus
        
        do {
            let data = try JSONEncoder().encode(downloadedEpisodes)
            UserDefaults.standard.set(data, forKey: K.UserDefaults.downloadedEpisodesKey)
        } catch {
            print("Failed to encode downloaded episodes with file url update:", error)
        }
    }
    
    func deleteEpisode(episode: Episode) {
        let episodes = fetchDownloadedEpisodes()
        let filteredEpisodes = episodes.filter { (e) -> Bool in
            return e.title != episode.title || (e.title == episode.title && e.fileUrl != episode.fileUrl)
        }
        do {
            let data = try JSONEncoder().encode(filteredEpisodes)
            UserDefaults.standard.set(data, forKey: K.UserDefaults.downloadedEpisodesKey)
        } catch { print("Failed to delete Episode:", error) }
    }

    //MARK: - Podcasts
    
    func fetchSavedPodcasts() -> [Podcast] {
        guard let data = UserDefaults.standard.data(forKey: K.UserDefaults.savedPodcastKey) else { return [] }
        do {
            let savedPodcasts = try JSONDecoder().decode([Podcast].self, from: data)
            return savedPodcasts
        } catch { print("Failed to decode Saved Podcasts:", error) }
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
        } catch { print("Failed to delete Podcast:", error) }
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
            } catch { print("Failed to encode Saved Podcasts:", error) }
        }
    }
    
    
    
    

    
}
