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
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    
    fileprivate func fetchEpisodes() {
        print("Looking for episodes at feed url:", podcast?.feedUrl ?? "")
        guard let feedUrl = podcast?.feedUrl else { return }
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes, podcast) in
            self.episodes = episodes
            self.selectedPodcast = podcast
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"

    var selectedPodcast = Podcast()
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBarButtons()
    }
    
    //MARK: - Setup
    
    fileprivate func setupNavigationBarButtons() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(handleDownloads)),
            UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(handleFetchSavedPodcasts))
        ]
    }
    
    @objc fileprivate func handleDownloads() {
        
    }
    
    @objc fileprivate func handleFetchSavedPodcasts() {
        print("Fetching saved Podcasts from UserDefaults")
        
//        guard let data = UserDefaults.standard.data(forKey: K.UserDefaults.savedPodcastKey) else { return }
//        do {
//            let savedPodcasts = try JSONDecoder().decode([Podcast].self, from: data)
        //            savedPodcasts.forEach { (podcast) in
        //                print(podcast.trackName ?? "")
        //            }
        //        } catch let decodeErr { print("Failed to decode Saved Podcasts:", decodeErr) }
        
        let listOfPodcasts = UserDefaults.standard.savedPodcasts()
        listOfPodcasts.forEach { (podcast) in
            print(podcast.trackName ?? "")
        }
    }

    
    
    
    
    
    
    
    
    fileprivate func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(EpisodeHeader.nib, forCellReuseIdentifier: headerId)
        tableView.register(EpisodeCell.nib, forCellReuseIdentifier: cellId)
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : episodes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let header = tableView.dequeueReusableCell(withIdentifier: headerId, for: indexPath) as! EpisodeHeader
            header.podcast = selectedPodcast

            // Expand and Collapse Podcast Description
            let expandCollapseTap = ExpandCollapseTapGestureRecognizer(target: self, action: #selector(didTapExpandCollapse(_:)))
            header.descriptionLabel.isUserInteractionEnabled = true
            header.descriptionLabel.addGestureRecognizer(expandCollapseTap)
            expandCollapseTap.header = header
                        
            return header
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EpisodeCell else { fatalError() }
            let episode = episodes[indexPath.row]
            cell.episode = episode
            return cell
        }
    }
    
    @objc func didTapExpandCollapse(_ sender: ExpandCollapseTapGestureRecognizer) {
        let header = sender.header
        header.descriptionLabel.numberOfLines = header.descriptionLabel.numberOfLines == 0 ? 3 : 0
        UIView.animate(withDuration: 1.0) {
            self.tableView.reloadData()
        }
    }
    
    
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 0 ? UITableView.automaticDimension : K.episodeCellHeight
    }
    
    
    
    
    

}





class ExpandCollapseTapGestureRecognizer: UITapGestureRecognizer {
    var header = EpisodeHeader()
}
