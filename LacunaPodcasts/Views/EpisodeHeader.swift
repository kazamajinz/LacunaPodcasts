//
//  EpisodeHeader.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-06-30.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit
import SafariServices

class EpisodeHeader: UITableViewCell {
    
    static var reuseIdentifier: String { String(describing: self) }
    static var nib: UINib { return UINib(nibName: String(describing: self), bundle: nil) }
    
    @IBOutlet weak var podcastImageView: UIImageView! {
        didSet {
            podcastImageView.roundCorners(cornerRadius: 8.0)
        }
    }
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followButton: FollowButton!
    
    var artistNameLabelAction: (() -> Void)?
    var descriptionLabelAction: (() -> Void)?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        selectedBackgroundView?.isHidden = true
    }
    
    private func styleDescriptionText(_ string: String) -> NSAttributedString? {
        let length = 120; let ellipsis = "... " ; let text = "more"
        guard let collapsedText = string.collapseText(to: length, ellipsis: ellipsis, text: text) else { return nil }
        let styledText = makeUrlLook(with: collapsedText, range: NSRange(location: length + ellipsis.count + 1, length: text.count), underline: false)
        return styledText
    }
    
    private func makeUrlLook(with text: String, range: NSRange, underline: Bool) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        var attributes: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.appColor(.orange) ?? UIColor.white]
        if underline == true { attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue }
        attributedString.addAttributes(attributes, range: range)
        return attributedString
    }
    
    var podcast: Podcast! {
        didSet {
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            podcastImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "appicon"), completed: nil)
            trackNameLabel.text = podcast.trackName
            
            // Artist Name
            artistNameLabel.text = podcast.artistName
            if let text = artistNameLabel.text {
                artistNameLabel.attributedText = makeUrlLook(with: text, range: NSRange(location: 0, length: text.count), underline: true)
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapArtistName))
            artistNameLabel.isUserInteractionEnabled = true
            artistNameLabel.addGestureRecognizer(tap)
            
            // Description
            descriptionLabel.text = podcast.description?.stripOutHtml()
            if descriptionLabel.numberOfLines != 0 {
                if let text = descriptionLabel.text {
                    if let styledText = styleDescriptionText(text) {
                        descriptionLabel.attributedText = styledText
                    }
                }
            }
            descriptionLabel.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDescriptionTap))
            descriptionLabel.addGestureRecognizer(tapGesture)
            
            // FOLLOW BUTTON
            let savedPodcasts = UserDefaults.standard.fetchSavedPodcasts()
            if let podcast = podcast {
                followButton.isSelected = savedPodcasts.contains(podcast) ? true : false
            }
        }
    }

    //MARK: - User Actions
    
    @objc func handleDescriptionTap() {
        descriptionLabelAction?()
        descriptionLabel.numberOfLines = descriptionLabel.numberOfLines == 0 ? 3 : 0
        //self?.tableView.reloadData()
        
    }

    @objc func didTapArtistName() {
        artistNameLabelAction?()
    }
    
    @IBAction func didPressFollow(_ sender: UIButton) {
        guard let podcast = podcast else { return }
        UserDefaults.standard.savePodcast(podcast: podcast)
        sender.isSelected.toggle()
    }
 
}

