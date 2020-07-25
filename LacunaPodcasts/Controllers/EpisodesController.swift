//
//  EpisodesController.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-06-29.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit
import FeedKit

enum Section: Int, CaseIterable {
    case header, episode
}

class EpisodesController: UITableViewController {
    
    //MARK: - Variables and Properties

    var selectedPodcast = Podcast()
    var episodes = [Episode]()
    var filteredEpisodes: [Episode] = []
    var timer: Timer?
    let searchController = SearchController(searchResultsController: SearchResultsController())
    var podcast: Podcast? {
        didSet {
            fetchEpisodes()
            navigationItem.title = self.podcast?.trackName
            view.backgroundColor = UIColor(named: K.Colors.midnight)
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
    
    //MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        setupObservers()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handlePlayerDetailsMinimize()
        tableView.reloadData()
    }
    
    //MARK: - Setup Observers
    
    fileprivate func reload(_ row: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: 1)], with: .none)
    }
    
    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadCancel), name: .downloadCancel, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlayerDetailsMinimize), name: .minimizePlayerDetails, object: nil)
    }
    
    @objc fileprivate func handleDownloadProgress(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let progress = userInfo["progress"] as? Double else { return }
        guard let title = userInfo["title"] as? String else { return }
        guard let index = self.episodes.firstIndex(where: {$0.title == title}) else { return }
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 1)) as? EpisodeCell else { return }
        self.episodes[index].downloadStatus = .inProgress

        // Update UI
        DispatchQueue.main.async {
            cell.updateDisplay(progress: progress)
        }
    }
    
    @objc fileprivate func handleDownloadCancel(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let title = userInfo["title"] as? String else { return }
        guard let index = self.episodes.firstIndex(where: {$0.title == title}) else { return }
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 1)) as? EpisodeCell else { return }
        self.episodes[index].downloadStatus = .none
        
        print("cancelling")

        // Update UI
        DispatchQueue.main.async {
            cell.resetUI()
        }
    }
    
    @objc fileprivate func handleDownloadComplete(notification: Notification) {
        guard let episodeDownloadComplete = notification.object as? APIService.EpisodeDownloadCompleteTuple else { return }
        guard let index = self.episodes.firstIndex(where: {$0.title == episodeDownloadComplete.episodeTitle}) else { return }
        self.episodes[index].fileUrl = episodeDownloadComplete.fileUrl
        self.episodes[index].downloadStatus = .completed
        
        // Remove from Active Downloads
        APIService.shared.activeDownloads[episodeDownloadComplete.streamUrl] = nil

        // Update UI
        DispatchQueue.main.async {
            self.reload(index)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    

    @objc fileprivate func handlePlayerDetailsMinimize() {
        if UIApplication.mainNavigationController()?.miniPlayerIsVisible == true {
            let miniPlayerViewHeight = UIApplication.mainNavigationController()?.minimizedTopAnchorConstraint.constant ?? 0
            //guard let safeAreaInsetBottom = UIWindow.key?.safeAreaInsets.bottom else { return }
            tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -miniPlayerViewHeight, right: 0)
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -miniPlayerViewHeight, right: 0)
        }
    }
    
    //MARK: - Setup
    
    var downloadsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.sizeToFit()
        return button
    }()
    
    fileprivate func setupTableView() {
        tableView.separatorColor = UIColor(named: K.Colors.blue)
        tableView.tableFooterView = UIView()
        tableView.register(EpisodeHeader.nib, forCellReuseIdentifier: EpisodeHeader.reuseIdentifier)
        tableView.register(EpisodeCell.nib, forCellReuseIdentifier: EpisodeCell.reuseIdentifier)
    }
    
    fileprivate func setupSearchBar() {
        guard let resultsController = searchController.searchResultsController as? SearchResultsController else { return }
        resultsController.delegate = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search episodes"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }
    
    //MARK: - Setup Gestures
    
    fileprivate func setupGestures() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: tableView)
        guard let selectedIndexPath = tableView.indexPathForRow(at: location) else { return }
        print("Long Press at:", selectedIndexPath.row)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let episode = episodes[indexPath.row]
            UIApplication.mainNavigationController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: episodes)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let activityIndicator = AlertService.showActivityIndicator()
            episodes.isEmpty ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
            return activityIndicator
        } else { return nil }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            if episodes.isEmpty { return K.episodeCellHeight } else { return 0 }
        } else { return 0 }
    }

    override func numberOfSections(in tableView: UITableView) -> Int { 2 }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 0 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : episodes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            guard let header = tableView.dequeueReusableCell(withIdentifier: EpisodeHeader.reuseIdentifier, for: indexPath) as? EpisodeHeader else { fatalError() }
            header.podcast = selectedPodcast

            // Expand and Collapse Podcast Description
            header.descriptionLabelAction = { [weak self] in
                header.descriptionLabel.numberOfLines = header.descriptionLabel.numberOfLines == 0 ? 3 : 0
                self?.tableView.reloadData()
            }
            return header
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseIdentifier, for: indexPath) as? EpisodeCell else { fatalError() }
            cell.delegate = self
            cell.episode = episodes[indexPath.row]
            let downloadedEpisodes = UserDefaults.standard.fetchDownloadedEpisodes()
            if let index = downloadedEpisodes.firstIndex(where: {$0.title == cell.episode.title} ) {
                cell.episode = downloadedEpisodes[index]
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
        guard let cell = tableView.cellForRow(at: indexPath) as? EpisodeCell else { return nil }
        guard let episode = cell.episode else { return nil }
        switch indexPath.section {
        case 1:
            
            if episode.downloadStatus != .completed {
                let downloadAction = SwipeActionService.createDownloadAction { (action, view, completionHandler) in
                    
                    // Check if episode is already downloading/downloaded
                    let downloadedEpisodes = UserDefaults.standard.fetchDownloadedEpisodes()
                    if !downloadedEpisodes.contains(where: {$0.title == episode.title}) {
                        
                        APIService.shared.startDownload(episode)
                        UserDefaults.standard.downloadEpisode(episode: episode)
                        DispatchQueue.main.async {
                            cell.updateDisplayForDownloadPending()
                        }
                    }
                    completionHandler(true)
                }
                let swipe = UISwipeActionsConfiguration(actions: [downloadAction])
                return swipe
                
            } else {
                    
                // Delete Action
                let deleteAction = SwipeActionService.createDeleteAction { (action, view, completionHandler) in
                    
                    // Delete Local File
                    guard let fileUrl = URL(string: episode.fileUrl ?? "") else { return }
                    let url = fileUrl.localFilePath()

                    if FileManager.default.fileExists(atPath: url.path) {
                        do {
                            try FileManager.default.removeItem(at: url)
                        } catch { print("Failed to delete the episode file:", error) }

                        // 1. Check If Episode Has Been Deleted
                        // 2. Check Storage Space
                        if !FileManager.default.fileExists(atPath: url.path) {
                            UserDefaults.standard.deleteEpisode(episode: episode)
                            self.fetchEpisodes()
                            self.reload(indexPath.row)
                        } else { print("Failed to delete the episode file") }
                    }
                    completionHandler(true)
                }
                let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
                return swipe
            }
        default: return nil
        }
    }
    
}

//MARK: - Episode Cell Delegate

extension EpisodesController: EpisodeCellDelegate {
    func didTapCancel(_ cell: EpisodeCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let episode = episodes[indexPath.row]
            APIService.shared.cancelDownload(episode)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

//MARK: - SearchController Delegate

extension EpisodesController: SearchResultsControllerDelegate {
    func didSelectSearchResult(_ episode: Episode) {
        self.searchController.searchBar.text = ""
        guard let index = episodes.firstIndex(where: {$0.title == episode.title}) else { return }
        let indexPath = IndexPath(row: index, section: 1)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
}

extension EpisodesController: UISearchControllerDelegate, UISearchResultsUpdating {
    func filterContentForSearchText(_ searchText: String) {
        filteredEpisodes = episodes.filter { (episode: Episode) -> Bool in
            return episode.title.lowercased().contains(searchText.lowercased()) || episode.description.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        self.filterContentForSearchText(searchBar.text!)

        if let resultsController = searchController.searchResultsController as? SearchResultsController {
            if filteredEpisodes.isEmpty { resultsController.noResults = true }
            resultsController.filteredEpisodes = filteredEpisodes
            resultsController.tableView.reloadData()
        }
    }
}

extension EpisodesController: UISearchBarDelegate {
}
