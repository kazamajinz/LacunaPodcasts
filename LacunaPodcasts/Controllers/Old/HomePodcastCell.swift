//
//  HomePodcastCell.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-08.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class HomePodcastCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    var podcast: Podcast! {
            didSet {
                nameLabel.text = podcast.trackName
                artistNameLabel.text = podcast.artistName

                guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
                podcastImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "appicon"), completed: nil)
            }
        }

}
