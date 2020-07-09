////
////  DatabaseManager.swift
////  LacunaPodcasts
////
////  Created by Priscilla Ip on 2020-07-09.
////  Copyright © 2020 Priscilla Ip. All rights reserved.
////
//
//import RealmSwift
//
//class DatabaseManager {
//    
//    static let shared = DatabaseManager()
//    private let realm = try! Realm()
//    private init() {}
//    
//    func fetchSavedPodcasts() -> PodcastSubscriptions? {
//        return realm.object(ofType: PodcastSubscriptions.self, forPrimaryKey: "podcastSubscriptions")
//    }
//    
//    func save(podcast: Podcast, to subscribed: PodcastSubscriptions) {
//        do {
//            try realm.write {
//                subscribed.podcasts.append(podcast)
//            }
//        } catch let err { print("Failed to save podcast:", err) }
//    }
//    
//    
//    
//    
//    func fetchDownloadedEpisodes() -> Results<Episode> {
//        return realm.objects(Episode.self)
//    }
//    
//    func download(episode: Episode) {
//        do {
//            try realm.write {
//                realm.add(episode, update: .modified)
//            }
//        } catch let err { print("Failed to download episode:", err) }
//    }
//    
//    
//    
//    
//    func delete(podcast: Podcast) {
//        
//    }
//    
//    
//    
//    
//    func delete(episode: Episode) {
//        do {
//            try realm.write {
//                realm.delete(episode)
//            }
//        } catch let err { print("Error deleting episode:", err) }
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//}
