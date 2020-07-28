//
//  SearchResultsController.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-13.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

protocol SearchResultsControllerDelegate: class {
    func didSelectSearchResult(_ episode: Episode)
}

class SearchResultsController: UITableViewController {
    
    weak var delegate: SearchResultsControllerDelegate?
    
    deinit { print("SearchResultsController memory being reclaimed...") }

    var filteredEpisodes: [Episode] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var isLoading: Bool = false {
        didSet {
            
            DispatchQueue.main.async {
                if self.view.checkIfSubViewOfTypeExists(type: UIActivityIndicatorView.self) == true {
                    self.noResultsView.isHidden = true
                } else { self.noResultsView.isHidden = false }
            }
            
            tableView.reloadData()
            
            
        }
    }
    
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        noResultsView.isHidden = true
    }
    
    // MARK: - Subviews
    
    let noResultsView: NoResultsView = {
        let view = NoResultsView()
        view.isHidden = true
        return view
    }()
    
    //MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = UIColor.appColor(.midnight)
        view.addSubview(noResultsView)
        setupLayouts()
    }
    
    private func setupLayouts() {
        noResultsView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        noResultsView.center(in: view, xAnchor: true, yAnchor: true)
    }
    
    fileprivate func setupTableView() {
        tableView.separatorColor = UIColor.appColor(.blue)
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
        cell.detailsLabel.isHidden = true
        cell.descriptionLabel.numberOfLines = 2
        DispatchQueue.main.async {
            cell.isActive = true
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        K.downloadEpisodeCellHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if isLoading {
            return AlertService.showActivityIndicator()
        } else {
            noResultsView.isHidden = false
            return UIView()
        }
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if filteredEpisodes.isEmpty {
            return K.downloadEpisodeCellHeight
        } else {
            noResultsView.isHidden = true
            return 0
        }
    }
}


