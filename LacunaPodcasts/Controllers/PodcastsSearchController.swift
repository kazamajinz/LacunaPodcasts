//
//  PodcastsSearchController.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-06-28.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    deinit { print("PodcastsSearchController memory being reclaimed...") }
    
    // MARK: - Variables and Properties
    
    var podcasts = [Podcast]()
    let searchController = UISearchController(searchResultsController: nil)
    var timer: Timer?
    var isLoading: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSearchBar()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.searchTextField.textColor = .white
        
        if UIApplication.mainNavigationController()?.miniPlayerIsVisible == true {
            let miniPlayerViewHeight = UIApplication.mainNavigationController()?.minimizedTopAnchorConstraint.constant ?? 0
            //guard let safeAreaInsetBottom = UIWindow.key?.safeAreaInsets.bottom else { return }
            tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -miniPlayerViewHeight, right: 0)
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -miniPlayerViewHeight, right: 0)
        }
    }
    
    // MARK: - Subviews
    
    let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Results"
        label.textColor = UIColor.appColor(.lightGray)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let noResultsView: NoResultsView = {
        let view = NoResultsView()
        view.isHidden = true
        return view
    }()
    
    //MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = UIColor.appColor(.midnight)
        navigationItem.title = "Add Podcast"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        view.addSubview(noResultsView)
        setupLayouts()
        
        noResultsView.isHidden = view.checkIfSubViewOfTypeExists(type: UIActivityIndicatorView.self) == true ? true : false
    }
    
    private func setupLayouts() {
        noResultsView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        noResultsView.center(in: view, xAnchor: true, yAnchor: false)
    }
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Directory"
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    fileprivate func setupTableView() {
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(PodcastCell.nib, forCellReuseIdentifier: PodcastCell.reuseIdentifier)
        tableView.keyboardDismissMode = .onDrag
    }
    
    //MARK: - TableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let podcast = self.podcasts[indexPath.row]
        let episodesController = EpisodesController()
        episodesController.podcast = podcast
        navigationController?.pushViewController(episodesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if isLoading {
            noResultsView.isHidden = true
            return AlertService.showActivityIndicator()
        } else {
            noResultsView.isHidden = false
            return UIView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if podcasts.isEmpty && searchController.searchBar.text?.isEmpty == false {
            return K.podcastCellHeight
        } else {
            noResultsView.isHidden = true
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PodcastCell.reuseIdentifier, for: indexPath) as? PodcastCell else { fatalError() }
        cell.podcast = self.podcasts[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        K.podcastCellHeight
    }
}

// MARK: - UISearchControllerDelegate, UISearchResultsUpdating

extension PodcastsSearchController: UISearchControllerDelegate, UISearchResultsUpdating {
    func filterContentForSearchText(_ searchText: String) {
        APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
            self.podcasts = podcasts
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.isLoading = false
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        isLoading = true
        tableView.reloadData()
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            self.filterContentForSearchText(searchBar.text!)
            self.noResultsView.searchTextLabel.text = "Couldn't find \"\(searchBar.text!)\""
        })
    }
}
