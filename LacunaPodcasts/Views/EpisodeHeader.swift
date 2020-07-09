//
//  EpisodeHeader.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-06-30.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class EpisodeHeader: UITableViewCell {
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    @IBOutlet weak var podcastImageView: UIImageView! {
        didSet {
            podcastImageView.roundCorners(cornerRadius: 8.0)
        }
    }
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followButton: FollowButton!
    
    var podcast: Podcast! {
        didSet {
            trackNameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            descriptionLabel.text = podcast.description
            
            if descriptionLabel.numberOfLines != 0 {
                    let collapsedText = descriptionLabel.text?.collapseText(to: 120)
                    descriptionLabel.text = collapsedText
            }

            let tap = UITapGestureRecognizer(target: self, action: #selector(didClickLink))
            artistNameLabel.isUserInteractionEnabled = true
            artistNameLabel.addGestureRecognizer(tap)
            
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            podcastImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "appicon"), completed: nil)
        }
    }

    //MARK: - User Actions
    
    @objc func didClickLink() {
        guard let url = URL(string: podcast.link ?? "") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func didPressFollow(_ sender: UIButton) {
        followButton.isSelected.toggle()

        // USER DEFAULTS
        print("Saving info into UserDefaults...")
        
        if let podcast = podcast {
            do {
                let data = try JSONEncoder().encode(podcast)
                UserDefaults.standard.set(data, forKey: K.followedPodcastKey)
                print("Successfully Encoded")
            } catch let encodeErr {
                print("Failed to encode Podcast:", encodeErr)
            }
        }
    }
    
    
    
    
    
}
