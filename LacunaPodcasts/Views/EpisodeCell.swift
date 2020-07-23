//
//  EpisodeCell.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-06-30.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

protocol EpisodeCellDelegate {
    func didTapCancel(_ cell: EpisodeCell)
}

class EpisodeCell: UITableViewCell {
    
    var delegate: EpisodeCellDelegate?
    
    static var reuseIdentifier: String { String(describing: self) }
    static var nib: UINib { return UINib(nibName: String(describing: self), bundle: nil) }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var downloadStatusView: UIView! {
        didSet {
            let circularProgressBar = CircularProgressBar()
            downloadStatusView.addSubview(circularProgressBar)
            circularProgressBar.center(in: downloadStatusView, xAnchor: true, yAnchor: true)
            circularProgressBar.action = {
                print("alskjflaskjdflkasjdf")
            }
            
//            let center = downloadStatusView.center
//
//
//            // Track Layer
//            let trackLayer = CAShapeLayer()
//            let circularPath = UIBezierPath(arcCenter: center, radius: 12, startAngle: -CGFloat.pi/2, endAngle: 2 * CGFloat.pi, clockwise: true)
//            trackLayer.path = circularPath.cgPath
//            trackLayer.strokeColor = UIColor(named: K.Colors.highlight)?.cgColor
//            trackLayer.lineWidth = 2
//            trackLayer.fillColor = UIColor.clear.cgColor
//            self.layer.addSublayer(trackLayer)
//
//            // Progress Bar
//            let shapeLayer = CAShapeLayer()
//            shapeLayer.path = circularPath.cgPath
//            shapeLayer.strokeColor = UIColor(named: K.Colors.orange)?.cgColor
//            shapeLayer.lineWidth = 2
//            shapeLayer.fillColor = UIColor.clear.cgColor
//            shapeLayer.lineCap = CAShapeLayerLineCap.round
//            shapeLayer.strokeEnd = 0
//            self.layer.addSublayer(shapeLayer)
//
//
        }
    }
    
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelButton.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedBackgroundView?.isHidden = true
        containerView.backgroundColor = selected ? UIColor(named: K.Colors.blue) : UIColor(named: K.Colors.darkBlue)
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        delegate?.didTapCancel(self)
    }

    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()

    var episode: Episode! {
        didSet {
            titleLabel.textColor = episode.downloadStatus.titleColor
            
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            episodeImageView.sd_setImage(with: url)
            titleLabel.text = episode.title
            descriptionLabel.text = episode.description.stripOutHtml()
            pubDateLabel.text = dateFormatter.string(from: episode.pubDate).uppercased()
            durationLabel.text = episode.duration.toDisplayString()

            // Non-nil Download object means a download is in progress
            if let _ = APIService.shared.activeDownloads[episode.streamUrl] { }
        }
    }
    
    func updateDisplay(progress: Double) {
        //cancelButton.isHidden = false
        pubDateLabel.text = "Downloading... \(Int(progress * 100))%"
    }
}
