//  NowPlayingTableViewCell.swift
//  The 10 - George
//
//  Created by George Garcia on 2/14/19.
//  Copyright © 2019 George Garcia. All rights reserved.
//

import UIKit

class NowPlayingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
        var data: Movie? {
        didSet {
            movieTitleLabel.text  = data?.title
            dateLabel.text        = data?.releaseDate
            ratingLabel.text      = data?.rating
            overViewLabel.text    = data?.overView
            
            if let id = data?.id {
                //print("the ID in dat", data?.id)
                NetworkingService.shared.getNowPlayingMoviePoster(movieId: id, success: { [weak self] (url) in
                    self?.posterImageView.download(url: url)
                }) { (error) in
                    // if not set default image
                }
                NetworkingService.shared.getGenre(movieId: id) { (genreName) in
                    self.genreLabel.text = genreName
                }
            }
            
            setupUI()
        }
    }
  
    
    func setupUI() {
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = 4
        
        ratingLabel.layer.masksToBounds = true
        ratingLabel.layer.cornerRadius  = 5
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
