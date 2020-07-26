//
//  PodcastCell.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-06-29.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    @IBOutlet weak var podcastImageView: UIImageView!  {
           didSet {
               podcastImageView.roundCorners(cornerRadius: 4.0)
           }
       }
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        selectedBackgroundView?.isHidden = true
        containerView.backgroundColor = selected ? .darkBlue : .midnight
    }
    
    var podcast: Podcast! {
        didSet {
            trackNameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            episodeCountLabel.text = "\(podcast.trackCount ?? 0) Episodes"

            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            podcastImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "appicon"), completed: nil)
            
//            URLSession.shared.dataTask(with: url) { (data, response, error) in
//                guard let data = data else { return }
//                DispatchQueue.main.async {
//                    self.podcastImageView.image = UIImage(data: data)
//                }
//            }.resume()
        }
    }
}
