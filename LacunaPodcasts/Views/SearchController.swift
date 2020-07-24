//
//  SearchController.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-23.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class SearchController:  UISearchController {
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        setupSearchController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSearchController() {
        searchBar.keyboardAppearance = .dark
        searchBar.searchTextField.backgroundColor = UIColor(named: K.Colors.midnight)
    }
    
}
