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

protocol APIServiceProtocol: class {
    func didFinishDownloading(episode: Episode, to fileUrl: String)
    func progress(episode: Episode, _ fractionCompleted: Double)
    func didFailWithError(error: Error)
}

extension Notification.Name {
    static let downloadProgress = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")
}

class APIService {
    
    static let shared = APIService()
    weak var delegate: APIServiceProtocol?
    
    let baseiTunesSearchURL = "https://itunes.apple.com/search?"

    //MARK: - Variables and Properties
    
    var activeDownloads: [String: Download] = [:]
    //typealias EpisodeDownloadCompleteTuple = (fileUrl: String, episodeTitle: String)
    
    //MARK: - Internal Methods

    func startDownload(_ episode: Episode) {

        print("Downloading episode using Alamofire at stream url:", episode.streamUrl)
        print("Current Active Downloads:", activeDownloads)
        
        let download = Download(episode: episode)
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        download.task = AF.download(episode.streamUrl, interceptor: nil, to: downloadRequest).downloadProgress { (progress) in
            download.isDownloading = true
            self.activeDownloads[download.episode.streamUrl] = download
            self.delegate?.progress(episode: episode, progress.fractionCompleted)

//            // Notify DownloadsController About Download Progress
//            NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title": episode.title, "progress": progress.fractionCompleted])
            
        }.response { (response) in
            //debugPrint(response)
            
            guard let fileUrl = response.fileURL?.path else { return }
            self.delegate?.didFinishDownloading(episode: episode, to: fileUrl)

//            let episodeDownloadComplete = EpisodeDownloadCompleteTuple(fileUrl: response.fileURL?.path ?? "", episode.title)
//            NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete, userInfo: nil)
            
            
            
            
            
            
            
            // Update UserDefaults
            var downloadedEpisodes = UserDefaults.standard.fetchDownloadedEpisodes()
            guard let index = downloadedEpisodes.firstIndex(where: {$0.title == episode.title && $0.collectionId == episode.collectionId} ) else { return }
            downloadedEpisodes[index].fileUrl = response.fileURL?.path ?? ""
            
            do {
                let data = try JSONEncoder().encode(downloadedEpisodes)
                UserDefaults.standard.set(data, forKey: K.UserDefaults.downloadedEpisodeKey)
            } catch let err {
                
                //self.delegate?.didFailWithError(error: error!)
                
                print("Failed to encode downloaded episodes with file url update:", err)
            }
        }
    }
    
    func cancelDownload(_ episode: Episode) {
        guard let download = activeDownloads[episode.streamUrl] else { return }
        download.task?.cancel()
        activeDownloads[episode.streamUrl] = nil
    }
    
    
    
    
    
//    func cancelDownload(episode: Episode) {
//        
//        print("Cancelling Episode:", episode.title)
//        print("Stream URL:", episode.streamUrl)
//        
//        // TODO: FIGURE OUT HOW TO CANCEL THE SPECIFIC DOWNLOAD TASK
//        
//        AF.session.getAllTasks { (sessionTasks) in
//            for task in sessionTasks {
//                if task.currentRequest?.url?.path == episode.streamUrl {
//                    print("Task exists here")
//                }
//            }
//        }
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode], Podcast) -> Void) {
        
        //let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: feedUrl) else { print("Error: \(feedUrl) is not a valid URL."); return }
        
        print("Before Parser")
        let parser = FeedParser(URL: url)
        print("After Parser")
        
        DispatchQueue.global(qos: .background).async {
            parser.parseAsync { (result) in
                print("Successfully parsed feed:", result)

                switch result {
                case .success(let feed):
                    guard let feed = feed.rssFeed else { return }
                    
                    // Podcast Details
                    var podcast = Podcast()
                    podcast.description = feed.description
                    
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
                print("Failed to Request URL, ", err)
                return
            }
            guard let data = dataResponse.data else { return }
            do {
                
                // decoder.keyDecodingStrategy = .convertFromSnakeCase
                
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
