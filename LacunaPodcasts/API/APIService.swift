//
//  APIService.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-06-29.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

extension Notification.Name {
    static let downloadProgress = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")
    static let downloadCancel = NSNotification.Name("downloadCancel")
}

class APIService {
    
    static let shared = APIService()

    //MARK: - Variables and Properties

    let baseiTunesSearchURL = "https://itunes.apple.com/search?"
    var activeDownloads: [String: Download] = [:]
    typealias EpisodeDownloadCompleteTuple = (fileUrl: String, episodeTitle: String, streamUrl: String)
    
    //MARK: - Internal Methods

    func startDownload(_ episode: Episode) {
        print("Downloading episode using Alamofire at stream url:", episode.streamUrl)
        print("Active Downloads:", activeDownloads)
        
        let download = Download(episode: episode)
        let destination = DownloadRequest.suggestedDownloadDestination()
        download.task = AF.download(episode.streamUrl, interceptor: nil, to: destination).downloadProgress { (progress) in
            self.activeDownloads[download.episode.streamUrl] = download
            
            NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title": episode.title, "progress": progress.fractionCompleted])
            
        }.response { (response) in
            if let error = response.error {

                // If Download is Cancelled
                print("The download for episode, \(episode.title), has been cancelled.", error.localizedDescription)
                NotificationCenter.default.post(name: .downloadCancel, object: nil, userInfo: ["title": episode.title])
                UserDefaults.standard.deleteEpisode(episode: episode)
                
            } else {
                
                print("Finished downloading episode: \(episode.title), to \(response.fileURL?.path ?? "")")
                
                let episodeDownloadComplete = EpisodeDownloadCompleteTuple(fileUrl: response.fileURL?.path ?? "", episode.title, episode.streamUrl)
                NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete, userInfo: nil)
                
                // Update UserDefaults
                var downloadedEpisodes = UserDefaults.standard.fetchDownloadedEpisodes()
                guard let index = downloadedEpisodes.firstIndex(where: {$0.title == episode.title && $0.streamUrl == episode.streamUrl} ) else { return }
                downloadedEpisodes[index].fileUrl = response.fileURL?.absoluteString ?? ""
                downloadedEpisodes[index].isDownloaded = true
                downloadedEpisodes[index].downloadStatus = .completed
                
                do {
                    let data = try JSONEncoder().encode(downloadedEpisodes)
                    UserDefaults.standard.set(data, forKey: K.UserDefaults.downloadedEpisodesKey)
                } catch {
                    print("Failed to encode downloaded episodes with file url update:", error)
                }
            }
        }
    }
    
    func cancelDownload(_ episode: Episode) {
        guard let download = activeDownloads[episode.streamUrl] else { return }
        download.task?.cancel()
        activeDownloads[episode.streamUrl] = nil
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode], Podcast) -> Void) {
        
        //let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: feedUrl) else { print("Error: \(feedUrl) is not a valid URL."); return }
        
        print("Before Parser")
        let parser = FeedParser(URL: url)
        print("After Parser")
        
        DispatchQueue.global(qos: .userInitiated).async {
            parser.parseAsync { (result) in
                print("Successfully parsed feed:", result)

                switch result {
                case .success(let feed):
                    
                    guard let feed = feed.rssFeed else { return }
                    
                    // Podcast Details
                    var podcast = Podcast()
                    podcast.description = feed.description
                    podcast.link = feed.link

                    // Episodes
                    let episodes = feed.toEpisodes()
                    completionHandler(episodes, podcast)
                    
                case .failure(let error):
                    print("Failed to parse XML feed:", error)
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    

    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        
        let parameters = ["term": searchText,
                          "country": "US",
                          "media": "podcast"]

        AF.request(baseiTunesSearchURL, parameters: parameters).responseData { (dataResponse) in
            
            if let err = dataResponse.error {
                print("Failed to Request URL", err)
                return
            }
            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                completionHandler(searchResult.results)
            } catch let decodeErr {
                print("Failed to decode, ", decodeErr)
            }
        }
    }
}

struct SearchResults: Codable {
    let resultCount: Int
    let results: [Podcast]
}
