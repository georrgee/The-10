//  UpcomingDetailsViewController.swift
//  The 10 - George
//  Created by George Garcia on 2/17/19.
//  Copyright © 2019 George Garcia. All rights reserved.

//  Description: NowPlayingDetailsViewController to show details for a specific movie


import UIKit

class UpcomingDetailsViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var blurBackgroundImageView:     UIImageView!
    @IBOutlet weak var movieTitleLabel:             UILabel!
    @IBOutlet weak var genreLabel:                  UILabel!
    @IBOutlet weak var posterImageView:             UIImageView!
    @IBOutlet weak var releaseDateLabel:            UILabel!
    @IBOutlet weak var overviewView:                UIView!
    @IBOutlet weak var overviewLabel:               UILabel!
    
    // MARK: Properties
    var movie: Movie?
    
    // MARK: View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBlurImage()
        setupIBOutlets()
        setupNavigationBar()
    }
    
    // MARK: UI Customization

    private func setupIBOutlets(){
        movieTitleLabel.text    = movie?.title
        releaseDateLabel.text   = movie?.releaseDate
        overviewLabel.text      = movie?.overView
        
        getImagesFromNetwork()
        
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
        navigationItem.title = "Movie Details"
        setupWatchNavigationButton()
    }
    
    private func setupWatchNavigationButton() {
        let watchBarButton = UIBarButtonItem(title: "Watch", style: .plain, target: nil, action: nil)
        watchBarButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Avenir-Light", size: 16)!, NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        navigationItem.rightBarButtonItem = watchBarButton
    }
    
     // MARK: Networking - Grabbing images from the database
    
    private func getImagesFromNetwork(){
        if let id = movie?.id {
            NetworkingService.shared.getGenre(movieId: id) { (genreName) in
                self.genreLabel.text = genreName
            }
            
            NetworkingService.shared.getNowPlayingMoviePoster(movieId: id, success: { (url) in
                self.posterImageView.download(url: url)
                self.blurBackgroundImageView.download(url: url)
            }) { (error) in }
        }
    }
    
    // MARK: ViewController Creation
    
    // function to create a viewcontroller hence creating a UpcomingDetailsViewController
    static func createViewController() -> UpcomingDetailsViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpcomingDetailsViewController") as! UpcomingDetailsViewController
    }
    
}
