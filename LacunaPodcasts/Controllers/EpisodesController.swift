//
//  EpisodesController.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-06-29.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit
import FeedKit
import SafariServices

class EpisodesController: UITableViewController {
    
    deinit { print("EpisodesController memory being reclaimed...") }
    
    //MARK: - Variables and Properties

    var episodes = [Episode]()
    var filteredEpisodes: [Episode] = []
    var timer: Timer?
    let searchController = UISearchController(searchResultsController: SearchResultsController())
    var selectedPodcast = Podcast()
    var podcast: Podcast? {
        didSet {
            if let podcast = podcast { selectedPodcast = podcast }
            fetchEpisodes()
            navigationItem.title = isPodcastSaved ? self.podcast?.trackName : "Add Podcast"
            view.backgroundColor = UIColor(named: K.Colors.midnight)
        }
    }
    
    var savedPodcasts: [Podcast] {
        return UserDefaults.standard.fetchSavedPodcasts()
    }
    var isPodcastSaved: Bool {
        guard let podcast = podcast else { return false }
        return savedPodcasts.contains(podcast)
    }

    private func fetchEpisodes() {
        print("Looking for episodes at feed url:", podcast?.feedUrl ?? "")
        guard let feedUrl = podcast?.feedUrl else { return }
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes, pod) in
            self.episodes = episodes
            self.selectedPodcast.description = pod.description
            self.selectedPodcast.link = pod.link
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.searchTextField.textColor = .white
    }
    
    //MARK: - Setup Observers
    
    fileprivate func reload(_ row: Int) {
        UIView.setAnimationsEnabled(false)
        tableView.reloadRows(at: [IndexPath(row: row, section: 1)], with: .none)
        UIView.setAnimationsEnabled(true)
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
//        guard let userInfo = notification.userInfo as? [String: Any] else { return }
//        guard let title = userInfo["title"] as? String else { return }
//        guard let index = self.episodes.firstIndex(where: {$0.title == title}) else { return }
//        self.episodes[index].downloadStatus = .none
//
//        // Update UI
//        DispatchQueue.main.async {
//            self.reload(index)
//        }
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
        section == 1 ? AlertService.showActivityIndicator() : nil
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
            
            if let index = savedPodcasts.firstIndex(where: {$0.trackName == selectedPodcast.trackName} ) {
                header.podcast = savedPodcasts[index]
            }
            
            // TODO: FIX RETAIN CYCLE ERRORS HERE
            
            // Show Podcast Link
            header.artistNameLabelAction = { [weak self] in
                guard let podcast = self?.podcast else { return }
                guard let url = URL(string: podcast.link ?? "") else { return }
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = false
                let vc = SFSafariViewController(url: url, configuration: config)
                self?.present(vc, animated: true, completion: nil)
            }
            
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
    
    private func fetchEpisodesAndUpdateUI(_ row: Int) {
        guard let feedUrl = self.podcast?.feedUrl else { return }
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes, pod) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.reload(row)
            }
        }
    }
    
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
                        
                        // HANDLE CANCEL FIX HERE

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
                            self.fetchEpisodesAndUpdateUI(indexPath.row)
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
            reload(indexPath.row)
        }
    }
}

//MARK: - SearchController Delegate

extension EpisodesController: SearchResultsControllerDelegate {
    func didSelectSearchResult(_ episode: Episode) {
        self.searchController.searchBar.text = ""
        guard let index = episodes.firstIndex(where: {$0.title == episode.title && $0.streamUrl == episode.streamUrl}) else { return }
        let indexPath = IndexPath(row: index, section: 1)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
    }
}

extension EpisodesController: UISearchControllerDelegate, UISearchResultsUpdating {
    func filterContentForSearchText(_ searchText: String) {
        filteredEpisodes = episodes.filter { (episode: Episode) -> Bool in
            return episode.title.lowercased().contains(searchText.lowercased()) || episode.description.lowercased().contains(searchText.lowercased()) ||
                episode.keywords.lowercased().contains(searchText.lowercased())
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsController else { fatalError("The search results controller cannot be found")}
        let searchBar = searchController.searchBar
        
        resultsController.isLoading = true
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (timer) in
            self.filterContentForSearchText(searchBar.text!)
            resultsController.isLoading = false
            resultsController.filteredEpisodes = self.filteredEpisodes
        })
    }
}

extension EpisodesController: UISearchBarDelegate {
}





