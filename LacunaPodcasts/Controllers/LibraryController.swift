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
    let searchController = UISearchController(searchResultsController: nil)
    var episodes = [Episode]()
    var podcasts = UserDefaults.standard.fetchSavedPodcasts()
    
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
    
    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = UIColor(named: K.Colors.midnight)
        navigationItem.title = "My Library"
        
        // Removes Text from Back Button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    fileprivate func setupTableView() {
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





extension LibraryController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
}

















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
