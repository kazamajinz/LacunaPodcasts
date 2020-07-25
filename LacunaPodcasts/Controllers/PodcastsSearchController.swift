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
    
    var podcasts = [Podcast]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSearchBar()
        setupTableView()
        
        
        
        
        
        
        
        searchBar(searchController.searchBar, textDidChange: "Gimlet")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.searchTextField.textColor = UIColor.white
    }
    
    //MARK: - Setup
    
    private func setupView() {
        navigationItem.title = "Add Podcast"
        view.backgroundColor = UIColor(named: K.Colors.midnight)
    }
    
    fileprivate func setupSearchBar() {
        // Removes Text from Back Button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    fileprivate func setupTableView() {
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(PodcastCell.nib, forCellReuseIdentifier: PodcastCell.reuseIdentifier)
    }
    
    var timer: Timer?
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.tableView.reloadData()
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (timer) in
            
            //if self.podcasts.isEmpty { searchBar.isLoading = true }
            
            APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
                //searchBar.isLoading = false
                self.podcasts = podcasts
                self.tableView.reloadData()
            }
        })
    }
    
    
    
    
    
    
    
    //MARK: - TableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let podcast = self.podcasts[indexPath.row]
        let episodesController = EpisodesController()
        episodesController.podcast = podcast
        navigationController?.pushViewController(episodesController, animated: true)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Search for a Podcast"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.podcasts.count > 0 ? 0 : 250
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicator = AlertService.showActivityIndicator()
        podcasts.isEmpty && searchController.searchBar.text?.isEmpty == false ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        return activityIndicator
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return podcasts.isEmpty && searchController.searchBar.text?.isEmpty == false ? 80 : 0
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
