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
            
            
//            let tap = UITapGestureRecognizer(target: self, action: #selector(didClickLink))
//            artistNameLabel.isUserInteractionEnabled = true
//            artistNameLabel.addGestureRecognizer(tap)
            
            
            // IMAGE
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            podcastImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "appicon"), completed: nil)
            
            // FOLLOW BUTTON
            let savedPodcasts = UserDefaults.standard.fetchSavedPodcasts()
            if savedPodcasts.contains(podcast) {
                followButton.isSelected = true
            }
        }
    }

    //MARK: - User Actions
    
//    @objc func didClickLink() {
//        guard let url = URL(string: podcast.link ?? "") else { return }
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//    }
    
    
    @IBAction func didPressFollow(_ sender: UIButton) {

        guard let podcast = podcast else { return }
        
        // check to see if podcast is already saved
        var savedPodcasts = UserDefaults.standard.fetchSavedPodcasts()
        
        if savedPodcasts.contains(where: { $0.collectionId == self.podcast.collectionId }) {
            UserDefaults.standard.deletePodcast(podcast: podcast)
        } else {
            
            // just appends to the end
            savedPodcasts.append(podcast)
            
            do {
                let data = try JSONEncoder().encode(savedPodcasts)
                UserDefaults.standard.set(data, forKey: K.UserDefaults.savedPodcastKey)
            } catch let encodeErr { print("Failed to encode Saved Podcasts:", encodeErr) }
        }
        followButton.isSelected.toggle()
    }
    
    
    
    
    
    
    
}
