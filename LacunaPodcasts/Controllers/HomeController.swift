//
//  HomeController.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-08.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class Header: UICollectionReusableView {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.text = "Podcasts"
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}












class HomeController: UICollectionViewController {
    
    var podcasts = [Podcast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(HomePodcastCell.self, forCellWithReuseIdentifier: HomePodcastCell.reuseIdentifier)
        collectionView.register(Header.self, forSupplementaryViewOfKind: "categoryHeaderId", withReuseIdentifier: "headerId")
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath)
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePodcastCell.reuseIdentifier, for: indexPath) as? HomePodcastCell else { fatalError() }
//        let podcast = podcasts[indexPath.row]
//        cell.podcast = podcast
        return cell
    }
    
    
}
