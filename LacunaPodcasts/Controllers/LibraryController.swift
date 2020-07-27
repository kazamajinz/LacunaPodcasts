//
//  FavoritesController.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-08.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class LibraryController: UITableViewController {

    deinit { print("LibraryController memory being reclaimed...") }
    
    // MARK: - Variables and Properties
    
    var timer: Timer?
    let searchController = UISearchController(searchResultsController: SearchResultsController())
    var podcasts = UserDefaults.standard.fetchSavedPodcasts() {
        didSet {
            self.episodes.removeAll()
            podcasts.forEach { (podcast) in
                guard let feedUrl = podcast.feedUrl else { return }
                APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes, pod) in
                    self.episodes.append(contentsOf: episodes)
                }
            }g
            browsePodcastsView.isHidden = podcasts.isEmpty ? false : true
        }
    }
    var filteredEpisodes: [Episode] = []
    var episodes = [Episode]()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupSearchBar()
        setupNavigationBarButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        podcasts = UserDefaults.standard.fetchSavedPodcasts()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.searchTextField.textColor = .white
    }
    
    // MARK: - Subviews
    
    let browsePodcastsView: BrowsePodcastsView = {
        let view = BrowsePodcastsView()
        view.isHidden = true
        return view
    }()
    
    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = UIColor.appColor(.midnight)
        navigationItem.title = "My Library"
        
        // Removes Text from Back Button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        view.addSubview(browsePodcastsView)
        setupLayouts()
    }

    private func setupLayouts() {
        browsePodcastsView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        browsePodcastsView.center(in: view, xAnchor: true, yAnchor: true)
    }
    
    
    
    
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Library"
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    fileprivate func setupTableView() {
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(PodcastCell.nib, forCellReuseIdentifier: PodcastCell.reuseIdentifier)
    }
    
    fileprivate func setupNavigationBarButtons() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(handleAddPodcast)),
            UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(handleDownloads))
        ]
    }
    
    @objc fileprivate func handleDownloads() {
        let downloadsController = DownloadsController()
        downloadsController.navigationItem.title = "Downloads"
        navigationController?.pushViewController(downloadsController, animated: true)
    }
    
    @objc fileprivate func handleAddPodcast() {
        let podcastsSearchController = PodcastsSearchController()
        navigationController?.pushViewController(podcastsSearchController, animated: true)
    }
    
    //MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        episodesController.podcast = self.podcasts[indexPath.row]
        navigationController?.pushViewController(episodesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PodcastCell.reuseIdentifier, for: indexPath) as? PodcastCell else { fatalError() }
        let podcast = self.podcasts[indexPath.row]
        cell.podcast = podcast
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        K.podcastCellHeight
    }
    
    //MARK: - Swipe Actions
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //DELETE ACTION
        let deleteAction = SwipeActionService.createDeleteAction { (action, view, completionHandler) in
            let selectedPodcast = self.podcasts[indexPath.row]
            self.podcasts.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaults.standard.deletePodcast(podcast: selectedPodcast)
            completionHandler(true)
        }
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipe
    }
}

// MARK: - UISearchControllerDelegate, UISearchResultsUpdating

extension LibraryController: SearchResultsControllerDelegate {
    func didSelectSearchResult(_ episode: Episode) {
        self.searchController.searchBar.text = ""

//        // Find Podcast
//        guard let index = podcasts.firstIndex(where: {$0.collectionId == podcast.collectionId} ) else { return }
//        let podcast = self.podcasts[indexPath.row]
//
//        // Go to Podcast Episodes
//        let episodesController = EpisodesController()
//        episodesController.podcast = podcast
//        navigationController?.pushViewController(episodesController, animated: true)
//
//        // Select Row
//        guard let index = episodes.firstIndex(where: {$0.title == episode.title && $0.streamUrl == episode.streamUrl}) else { return }
//        let indexPath = IndexPath(row: index, section: 1)
//        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
    }
}

extension LibraryController: UISearchControllerDelegate, UISearchResultsUpdating {
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
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { [weak self] (timer) in
            guard let self = self else { return }
            self.filterContentForSearchText(searchBar.text!)
            resultsController.isLoading = false
            resultsController.filteredEpisodes = self.filteredEpisodes
        })   
    }
}

// MARK: - UISearchBarDelegate

extension LibraryController: UISearchBarDelegate { }




















//    let badgeSize: CGFloat = 16
//    let badgeTag = 9830384
//
//    func badgeLabel(withCount count: Int) -> UILabel {
//            let badgeCount = UILabel(frame: CGRect(x: 0, y: 0, width: badgeSize, height: badgeSize))
//            badgeCount.translatesAutoresizingMaskIntoConstraints = false
//            badgeCount.tag = badgeTag
//            badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
//            badgeCount.textAlignment = .center
//            badgeCount.layer.masksToBounds = true
//            badgeCount.textColor = .white
//            badgeCount.font = badgeCount.font.withSize(8)
//            badgeCount.backgroundColor = .systemBlue
//            badgeCount.text = String(count)
//            return badgeCount
//        }
//
//    func showBadge(withCount count: Int) {
//        let badge = badgeLabel(withCount: count)
//        downloadsButton.addSubview(badge)
//
//        NSLayoutConstraint.activate([
//            badge.leftAnchor.constraint(equalTo: downloadsButton.leftAnchor, constant: 14),
//            badge.topAnchor.constraint(equalTo: downloadsButton.topAnchor, constant: 4),
//            badge.widthAnchor.constraint(equalToConstant: badgeSize),
//            badge.heightAnchor.constraint(equalToConstant: badgeSize)
//        ])
//    }
