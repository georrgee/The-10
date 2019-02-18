//  NowPlayingTableViewCell.swift
//  The 10 - George
//  Created by George Garcia on 2/14/19.
//  Copyright © 2019 George Garcia. All rights reserved.

//  Description: Configuring the prototype cell for the NowPlayingTableViewController

import UIKit

class NowPlayingTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var movieTitleLabel:  UILabel!
    @IBOutlet weak var genreLabel:       UILabel!
    @IBOutlet weak var dateLabel:        UILabel!
    @IBOutlet weak var ratingLabel:      UILabel!
    @IBOutlet weak var overViewLabel:    UILabel!
    @IBOutlet weak var posterImageView:  UIImageView!
    
    // MARK: Properties
    var data: Movie? {
            
        didSet { 
            movieTitleLabel.text  = data?.title
            dateLabel.text        = data?.releaseDate
            ratingLabel.text      = data?.rating
            overViewLabel.text    = data?.overView
            
            if let id = data?.id {
                
                NetworkingService.shared.getNowPlayingMoviePoster(movieId: id, success: { [weak self] (url) in
                    self?.posterImageView.download(url: url)
                }) { (error) in }
                
                NetworkingService.shared.getGenre(movieId: id) { (genreName) in
                    self.genreLabel.text = genreName
                }
              }
            setupViewsUI()
        }
    }
  
    // MARK: UI Customization
    
    private func setupViewsUI() {     // customizing UIImageViews and UILabels
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius  = 4
        
        ratingLabel.layer.masksToBounds     = true
        ratingLabel.layer.cornerRadius      = 5
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
