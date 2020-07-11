//
//  EpisodesController.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-06-29.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    
    var podcast: Podcast? {
        didSet {
            fetchEpisodes()
            self.navigationItem.title = self.podcast?.trackName
        }
    }
    
    fileprivate func fetchEpisodes() {
        
        if let podcast = podcast {
            selectedPodcast = podcast
        }
        
        print("Looking for episodes at feed url:", podcast?.feedUrl ?? "")
        guard let feedUrl = podcast?.feedUrl else { return }
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes, pod) in
            self.episodes = episodes
            self.selectedPodcast.description = pod.description
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    var selectedPodcast = Podcast()
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIService.shared.delegate = self
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //MARK: - Setup
    
    var downloadsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.sizeToFit()
        return button
    }()
    
    
    

    
    
    
    
    
//    @objc fileprivate func handleFetchSavedPodcasts() {
//        print("Fetching saved Podcasts from UserDefaults")
//
////        guard let data = UserDefaults.standard.data(forKey: K.UserDefaults.savedPodcastKey) else { return }
////        do {
////            let savedPodcasts = try JSONDecoder().decode([Podcast].self, from: data)
//        //            savedPodcasts.forEach { (podcast) in
//        //                print(podcast.trackName ?? "")
//        //            }
//        //        } catch let decodeErr { print("Failed to decode Saved Podcasts:", decodeErr) }
//
//        let listOfPodcasts = UserDefaults.standard.fetchSavedPodcasts()
//        listOfPodcasts.forEach { (podcast) in
//            print(podcast.trackName ?? "")
//        }
//    }

    
    
    
    
    
    
    
    
    fileprivate func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(EpisodeHeader.nib, forCellReuseIdentifier: EpisodeHeader.reuseIdentifier)
        tableView.register(EpisodeCell.nib, forCellReuseIdentifier: EpisodeCell.reuseIdentifier)
    }
    
    //MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        AlertService.showActivityIndicator { (activityIndicator) in
            episodes.isEmpty ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        episodes.isEmpty ? 100 : 0
    }
    
    
    
    let playerDetailsView = PlayerDetailsView()
    
    var miniPlayerIsVisible: Bool = false {
        didSet {
//            if !miniPlayerIsVisible {
//                let miniPlayerViewHeight = UIApplication.mainTabBarController()?.minimizedTopAnchorConstraint.constant ?? 0
//                let tabBarHeight = UIApplication.mainTabBarController()?.tabBar.frame.size.height ?? 0
//                let offsetY = miniPlayerViewHeight + tabBarHeight
//                
//                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                    self.view.layoutIfNeeded()
//                })
//            }
        }
    }
   
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes, miniPlayerIsVisible: miniPlayerIsVisible)
        
        if !miniPlayerIsVisible { miniPlayerIsVisible.toggle() }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : episodes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            guard let header = tableView.dequeueReusableCell(withIdentifier: EpisodeHeader.reuseIdentifier, for: indexPath) as? EpisodeHeader else { fatalError() }
            header.podcast = selectedPodcast
            
            // Expand and Collapse Podcast Description
            header.descriptionLabelAction = { [weak self] in
                header.descriptionLabel.numberOfLines = header.descriptionLabel.numberOfLines == 0 ? 3 : 0
                UIView.animate(withDuration: 1.0) {
                    self?.tableView.reloadData()
                }
            }
        
            return header
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseIdentifier, for: indexPath) as? EpisodeCell else { fatalError() }
            cell.episode = episodes[indexPath.row]
            
            if let collectionId = podcast?.collectionId {
                cell.episode.collectionId = collectionId
            }
            
            return cell
        }
    }
    
    
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 0 ? UITableView.automaticDimension : K.episodeCellHeight
    }
    
    //MARK: - Swipe Actions
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // Download Action
        let downloadAction = SwipeActionService.createDownloadAction { (action, view, completionHandler) in
            let episode = self.episodes[indexPath.row]
            UserDefaults.standard.downloadEpisode(episode: episode)
            completionHandler(true)
            
            // Download Episode using Alamofire
            // Update UI - ???
            APIService.shared.startDownload(episode)

            
            
            
            
            
            
            
            
            

        }
        let swipe = UISwipeActionsConfiguration(actions: [downloadAction])
        return swipe
    }
    
    
    
    
    
    
    
    
    

}








extension EpisodesController: APIServiceProtocol {
    func didFinishDownloading(episode: Episode, to fileUrl: String) {
        print("Finished downloading episode: \(episode.title), to \(fileUrl)")
        
        
        
        
        
        
    }
    
    func progress(episode: Episode, _ fractionCompleted: Double) {
        print("Progress:", fractionCompleted)
        
        let url = episode.streamUrl
        guard let download = APIService.shared.activeDownloads[url] else { return }
        download.progress = fractionCompleted

        guard let index = self.episodes.firstIndex(where: {$0.title == episode.title}) else { return }
        DispatchQueue.main.async {
            if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 1)) as? EpisodeCell {
                cell.updateDisplay(progress: download.progress)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
