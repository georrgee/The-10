//  UpcomingTableViewCell.swift
//  The 10 - George
//  Created by George Garcia on 2/14/19.
//  Copyright © 2019 George Garcia. All rights reserved.

//  Description: Configuring the prototype cell for the UpcomingTableViewController

import UIKit

class UpcomingTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var posterImageView:     UIImageView!
    @IBOutlet weak var movieTitleLabel:     UILabel!
    @IBOutlet weak var overViewLabel:       UILabel!
    @IBOutlet weak var genreLabel:          UILabel!
    @IBOutlet weak var releaseDateLabel:    UILabel!
    @IBOutlet weak var ratingLabel:         UILabel!
    
    // MARk: Properties
    
    var data: Movie? {
        
        didSet {
            movieTitleLabel.text    = data?.title
            releaseDateLabel.text   = data?.releaseDate
            ratingLabel.text        = data?.rating
            overViewLabel.text      = data?.overView
            
            if let id = data?.id {
                
                NetworkingService.shared.getUpcomingMoviePoster(movieId: id, success: { [weak self](url) in
                    self?.posterImageView.download(url: url)
                }) { (error) in
                    // set default image
                }
                
                NetworkingService.shared.getGenre(movieId: id) { (genreName) in
                    self.genreLabel.text = genreName
                }
            }
            setupViewsUI()
        }
    }
    
    // MARK: UI Customization
    
    private func setupViewsUI() {        // Customizing UILabels and UIImageViews
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
