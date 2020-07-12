//
//  DownloadsController.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-09.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit
import Alamofire

class DownloadsController: UITableViewController {
    
    var episodes = UserDefaults.standard.fetchDownloadedEpisodes()
    
    deinit {
        print("DownloadsController memory being reclaimed...")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIService.shared.delegate = self
        setupTableView()
        setupObservers()
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
        
//        APIService.shared.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(EpisodeCell.nib, forCellReuseIdentifier: EpisodeCell.reuseIdentifier)
    }
    
    //MARK: - Setup Observers
    
    fileprivate func setupObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
    }
    
    @objc fileprivate func handleDownloadComplete(notification: Notification) {
        guard let episodeDownloadComplete = notification.object as? APIService.EpisodeDownloadCompleteTuple else { return }
        guard let index = self.episodes.firstIndex(where: {$0.title == episodeDownloadComplete.episodeTitle}) else { return }
        self.episodes[index].fileUrl = episodeDownloadComplete.fileUrl
        self.episodes[index].downloadStatus = .completed

        // Remove from Active Downloads
        APIService.shared.activeDownloads[episodeDownloadComplete.streamUrl] = nil
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }

//    @objc fileprivate func handleDownloadProgress(notification: Notification) {
//        guard let userInfo = notification.userInfo as? [String: Any] else { return }
//        guard let progress = userInfo["progress"] as? Double else { return }
//        guard let title = userInfo["title"] as? String else { return }
//        print(progress, title)
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - TableView

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        
        if episode.fileUrl != nil {
            UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
        } else {
            AlertService.showFileUrlNotFoundAlert(on: self) { (action) in
                UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseIdentifier, for: indexPath) as? EpisodeCell else { fatalError() }
        cell.delegate = self
        cell.episode = self.episodes[indexPath.row]
        cell.episodeImageView.isHidden = false
        cell.descriptionLabel.isHidden = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        K.downloadEpisodeCellHeight
    }
    
    //MARK: - Swipe Actions
    
    var timer: Timer?
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // Delete Action
        let deleteAction = SwipeActionService.createDeleteAction { (action, view, completionHandler) in
            let selectedEpisode = self.episodes[indexPath.row]

            // Delete Local File
            guard var trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            guard let fileUrl = URL(string: selectedEpisode.fileUrl ?? "") else { return }
            let fileName = fileUrl.lastPathComponent
            trueLocation.appendPathComponent(fileName)
        
            if FileManager.default.fileExists(atPath: trueLocation.path) {
                do {
                    try FileManager.default.removeItem(at: trueLocation)
                } catch { print("Failed to delete the episode file:", error) }
                
                // 1. Check If Episode Has Been Deleted
                // 2. Check Storage Space
                if !FileManager.default.fileExists(atPath: trueLocation.path) {
                    // Remove Episode
                    self.episodes.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    UserDefaults.standard.deleteEpisode(episode: selectedEpisode)
                } else {
                    print("Failed to delete the episode file")
                }
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            completionHandler(true)
        }
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipe
    }
    
    
}







//MARK: - APIService Protocol

extension DownloadsController: APIServiceProtocol {
    
    func didCancelDownloading(episode: Episode) {
        guard let index = self.episodes.firstIndex(where: {$0.title == episode.title}) else { return }
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadRows(at: [IndexPath(row: index, section: 1)], with: .none)
        }
    }
    
    func progress(episode: Episode, _ fractionCompleted: Double) {
        print("Progress:", fractionCompleted)
        
        guard let index = self.episodes.firstIndex(where: {$0.title == episode.title}) else { return }
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodeCell else { return }
        
        DispatchQueue.main.async {
            cell.updateDisplay(progress: fractionCompleted)
        }
    }
}

//MARK: - Episode Cell Delegate

extension DownloadsController: EpisodeCellDelegate {
    func didTapCancel(_ cell: EpisodeCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let episode = episodes[indexPath.row]
            APIService.shared.cancelDownload(episode)
            //tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
