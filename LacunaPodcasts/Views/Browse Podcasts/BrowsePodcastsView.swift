//
//  BrowsePodcastsView.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-27.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class BrowsePodcastsView: UIView {
    
    @IBOutlet var containerView: UIView!
    var browsePodcastsAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubViews() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: containerView.topAnchor),
            self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func setupView() {
        
    }
        
    @IBAction func didTapBrowsePodcasts(_ sender: Any) {
        browsePodcastsAction?()
    }
}
