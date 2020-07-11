//
//  EpisodeCell.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-06-30.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    static var reuseIdentifier: String { String(describing: self) }
    static var nib: UINib { return UINib(nibName: String(describing: self), bundle: nil) }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var cancelDownloadButton: UIButton!
    
    var cancelDownloadButtonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cancelDownloadButton.addTarget(self, action: #selector(handleCancelDownloadButtonTap), for: .touchUpInside)
    }
    
    @objc func handleCancelDownloadButtonTap() {
        cancelDownloadButtonAction?()
    }
    
    
    
    
    
    var episode: Episode! {
        didSet {
            
            // Episode Image
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            episodeImageView.sd_setImage(with: url)
            episodeImageView.isHidden = true
            
            
            
            titleLabel.text = episode.title
            descriptionLabel.text = episode.description.stripOutHtml()
            
            // PUB DATE
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            pubDateLabel.text = dateFormatter.string(from: episode.pubDate).uppercased()
            
            durationLabel.text = episode.duration.convertToEpisodeDurationString()
        }
    }
    
    
    
    
    
    func updateDisplay(progress: Double) {
        cancelDownloadButton.isHidden = false
        //progressLabel.isHidden = false
        //progressLabel.text = "\(Int(progress * 100))%"
        pubDateLabel.text = "Downloading... \(Int(progress * 100))%"
        
        // Download Finished
        if progress == 1 {
            //progressLabel.isHidden = true
            cancelDownloadButton.isHidden = true
        }
    }
    
    
    
    
    
    
}









//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }


