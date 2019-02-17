//
//  NowPlayingDetailsViewController.swift
//  The 10 - George
//
//  Created by George Garcia on 2/17/19.
//  Copyright © 2019 George Garcia. All rights reserved.
//

import UIKit

class NowPlayingDetailsViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var blurBackgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewView: UIView!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIBObjects()
        setupNavigationBar()
    }
    
    private func setupIBObjects() {
        movieTitleLabel.text    = movie?.title
        releaseDateLabel.text   = movie?.releaseDate
        overviewLabel.text      = movie?.overView
        
        setupBlurImage()
        getImagesFromNetwork()
    }
    
    private func getImagesFromNetwork(){
        if let id = movie?.id {
            NetworkingService.shared.getGenre(movieId: id) { (genreName) in
                self.genreLabel.text = genreName
            }
            NetworkingService.shared.getNowPlayingMoviePoster(movieId: id, success: { (url) in
                self.posterImageView.download(url: url)
                self.blurBackgroundImageView.download(url: url)
            }) { (error) in
                
            }
        }
    }
    
    private func setupBlurImage() {
        let blurEffect                  = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView              = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame            = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        blurBackgroundImageView.addSubview(blurEffectView)
    }
    
    private func setupNavigationBar(){
        navigationItem.largeTitleDisplayMode = .never
    }
    
    static func createViewController() -> NowPlayingDetailsViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NowPlayingDetailsViewController") as! NowPlayingDetailsViewController
    }
    
}
