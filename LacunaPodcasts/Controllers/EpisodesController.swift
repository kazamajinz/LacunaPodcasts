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
    
    //MARK: - Variables and Properties
    
    var filteredEpisodes: [Episode] = []
    var timer: Timer?
    
    
//    let episodesController = EpisodesController()
//    episodesController.podcast = podcast
    
    
    let searchController = UISearchController(searchResultsController: SearchResultsController())
    
    
    
    
    
    
    
    
    
    
    
    var podcast: Podcast? {
        didSet {
            fetchEpisodes()
            navigationItem.title = self.podcast?.trackName
            view.backgroundColor = UIColor(named: K.Colors.darkBlue)
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

    var selectedPodcast = Podcast()
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIService.shared.delegate = self
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
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlayerDetailsMinimize), name: .minimizePlayerDetails, object: nil)
    }

    @objc fileprivate func handleDownloadComplete(notification: Notification) {
        guard let episodeDownloadComplete = notification.object as? APIService.EpisodeDownloadCompleteTuple else { return }
        guard let index = self.episodes.firstIndex(where: {$0.title == episodeDownloadComplete.episodeTitle}) else { return }
        self.episodes[index].fileUrl = episodeDownloadComplete.fileUrl
        self.episodes[index].isDownloaded = true
        self.episodes[index].downloadStatus = .completed
        
        // Remove from Active Downloads
        APIService.shared.activeDownloads[episodeDownloadComplete.streamUrl] = nil
        
        // Update UI
        DispatchQueue.main.async { [weak self] in
            self?.reload(index)
        }
    }
    
    @objc fileprivate func handleDownloadProgress(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let progress = userInfo["progress"] as? Double else { return }
        guard let title = userInfo["title"] as? String else { return }
        
        guard let index = self.episodes.firstIndex(where: {$0.title == title}) else { return }
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 1)) as? EpisodeCell else { return }

        // Update UI
        DispatchQueue.main.async {
            cell.updateDisplay(progress: progress)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @objc fileprivate func handlePlayerDetailsMinimize() {
//        if UIApplication.mainTabBarController()?.miniPlayerIsVisible == true {
            //let miniPlayerViewHeight = UIApplication.mainTabBarController()?.minimizedTopAnchorConstraint.constant ?? 0
            //let tabBarHeight = UIApplication.mainTabBarController()?.tabBar.frame.size.height ?? 0
            //let offsetY = abs(miniPlayerViewHeight) + tabBarHeight
            //print(miniPlayerViewHeight, tabBarHeight, offsetY)
            
            //tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -miniPlayerViewHeight, right: 0)
            //tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -miniPlayerViewHeight, right: 0)
//        }
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
        let activityIndicator = AlertService.showActivityIndicator()
        episodes.isEmpty ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        return activityIndicator
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        episodes.isEmpty ? 100 : 0
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
                UIView.animate(withDuration: 1.0) {
                    self?.tableView.reloadData()
                }
            }
        
            return header
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseIdentifier, for: indexPath) as? EpisodeCell else { fatalError() }
            cell.delegate = self
            cell.episode = episodes[indexPath.row]

            if let collectionId = podcast?.collectionId {
                cell.episode.collectionId = collectionId
            }
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.separatorInset = UIEdgeInsets.zero
//        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 0 ? UITableView.automaticDimension : K.episodeCellHeight
    }
    
    //MARK: - Swipe Actions
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let episode = self.episodes[indexPath.row]
        
        if indexPath.section != 0 {
            if !episode.isDownloaded {

                // Download Action
                let downloadAction = SwipeActionService.createDownloadAction { (action, view, completionHandler) in
                    
                    // Check if Episode is already downloaded
                    let episodes = UserDefaults.standard.fetchDownloadedEpisodes()
                    if !episodes.contains(where: {$0.collectionId == episode.collectionId && $0.title == episode.title }) {
                        APIService.shared.startDownload(episode)
                        UserDefaults.standard.downloadEpisode(episode: episode)
                        
                        // Waiting for download...
                        guard let cell = tableView.cellForRow(at: indexPath) as? EpisodeCell else { return }
                        cell.pubDateLabel.text = "Waiting for download..."
                    }
                    completionHandler(true)
                }
                let swipe = UISwipeActionsConfiguration(actions: [downloadAction])
                return swipe
                
            } else {
                print("Episode is either downloading or already downloaded...")
                
                // Delete Action
                let deleteAction = SwipeActionService.createDeleteAction { (action, view, completionHandler) in
                    print("Delete Downloaded Episode...")
                    completionHandler(true)
                }
                let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
                return swipe
            }
            
        } else { return nil }
    }
    
}




//MARK: - APIService Protocol

extension EpisodesController: APIServiceProtocol {
}

//MARK: - Episode Cell Delegate

extension EpisodesController: EpisodeCellDelegate {
    func didTapCancel(_ cell: EpisodeCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let episode = episodes[indexPath.row]
            APIService.shared.cancelDownload(episode)
            UserDefaults.standard.deleteEpisode(episode: episode)
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
