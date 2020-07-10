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

class APIService {
    
    static let shared = APIService()
    
    func downloadEpisode(episode: Episode) {
        
        print("Downloading episode using Alamofire at stream url:", episode.streamUrl)
        
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        AF.download(episode.streamUrl, interceptor: nil, to: downloadRequest).downloadProgress { (progress) in
            print("Download Progress:", progress.fractionCompleted)
        }.response { (response) in
            //debugPrint(response)
            
            print(response.fileURL?.absoluteString ?? "")
            
            // Update UserDefaults
            var downloadedEpisodes = UserDefaults.standard.fetchDownloadedEpisodes()
            guard let index = downloadedEpisodes.firstIndex(where: {$0.title == episode.title && $0.collectionId == episode.collectionId} ) else { return }
            downloadedEpisodes[index].fileUrl = response.fileURL?.absoluteString ?? ""
            
            do {
                let data = try JSONEncoder().encode(downloadedEpisodes)
                UserDefaults.standard.set(data, forKey: K.UserDefaults.downloadedEpisodeKey)
            } catch let err {
                print("Failed to encode downloaded episodes with file url update:", err)
            }
            
            

        }
        
    }
    
    
    
    
    
    
    
    
    
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
    
    
    
    
    
    
    
    
    
    
    
    let baseiTunesSearchURL = "https://itunes.apple.com/search?"

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
