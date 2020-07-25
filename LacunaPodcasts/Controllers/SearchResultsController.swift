//
//  SearchResultsController.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-13.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

protocol SearchResultsControllerDelegate {
    func didSelectSearchResult(_ episode: Episode)
}

class SearchResultsController: UITableViewController {
    
    var delegate: SearchResultsControllerDelegate?
    
    deinit { print("SearchResultsController memory being reclaimed...") }

    var filteredEpisodes: [Episode] = []
    var noResults: Bool = false
    
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    //MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = UIColor.midnight
    }
    
    fileprivate func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(EpisodeCell.nib, forCellReuseIdentifier: EpisodeCell.reuseIdentifier)
    }
    
    //MARK: - TableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = filteredEpisodes[indexPath.row]
        dismiss(animated: true) {
            self.delegate?.didSelectSearchResult(episode)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredEpisodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseIdentifier, for: indexPath) as? EpisodeCell else { fatalError() }
        cell.episode = filteredEpisodes[indexPath.row]
        cell.episodeImageView.isHidden = false
        cell.descriptionLabel.numberOfLines = 1
        cell.isActive = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        K.downloadEpisodeCellHeight
    }
    
    
    
    
    
    
    
    let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicator = AlertService.showActivityIndicator()
        activityIndicator.startAnimating()
        return noResults ? noResultsLabel : activityIndicator
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return filteredEpisodes.isEmpty ? K.downloadEpisodeCellHeight : 0
    }
}


