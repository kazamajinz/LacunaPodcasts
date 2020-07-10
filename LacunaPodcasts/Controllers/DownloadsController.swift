//
//  DownloadsController.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-09.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class DownloadsController: UITableViewController {
    
    var episodes = UserDefaults.standard.fetchDownloadedEpisodes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDownloadedEpisodes()
    }
    
    fileprivate func fetchDownloadedEpisodes() {
        episodes = UserDefaults.standard.fetchDownloadedEpisodes()
        tableView.reloadData()
    }
    
    
    //MARK: - Setup
    
    fileprivate func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(EpisodeCell.nib, forCellReuseIdentifier: EpisodeCell.reuseIdentifier)
    }
    
    //MARK: - TableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        
        UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: episodes)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseIdentifier, for: indexPath) as? EpisodeCell else { fatalError() }
        cell.episode = self.episodes[indexPath.row]
        cell.episodeImageView.isHidden = false
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        K.episodeCellHeight
    }
    
    //MARK: - Swipe Actions
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        //DELETE ACTION
        let deleteAction = SwipeActionService.createDeleteAction { (action, view, completionHandler) in
            let selectedEpisode = self.episodes[indexPath.row]
            self.episodes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaults.standard.deleteEpisode(episode: selectedEpisode)
            completionHandler(true)
        }
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipe
    }
    
    
}
