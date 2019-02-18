//  NowPlayingDetailsViewController.swift
//  The 10 - George
//  Created by George Garcia on 2/17/19.
//  Copyright © 2019 George Garcia. All rights reserved.

//  Description: NowPlayingDetailsViewController to show details for a specific movie

import UIKit

class NowPlayingDetailsViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var blurBackgroundImageView:  UIImageView!
    @IBOutlet weak var posterImageView:          UIImageView!
    @IBOutlet weak var movieTitleLabel:          UILabel!
    @IBOutlet weak var genreLabel:               UILabel!
    @IBOutlet weak var releaseDateLabel:         UILabel!
    @IBOutlet weak var overviewView:             UIView!
    @IBOutlet weak var overviewLabel:            UILabel!
    
    // MARK: Properties
    var movie: Movie?
    
    // MARK: View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIBObjects()
        setupNavigationBar()
    }
    
    // MARK: UI Customization
    
    private func setupIBObjects() {    // Assigning the outlets to their specific attributes
        movieTitleLabel.text    = movie?.title
        releaseDateLabel.text   = movie?.releaseDate
        overviewLabel.text      = movie?.overView
        
        setupBlurImage()
        getImagesAndGenres()
    }
    
    private func setupBlurImage() {    // creating a blur effect of the image for the background
        let blurEffect                  = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView              = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame            = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        blurBackgroundImageView.addSubview(blurEffectView)
    }
    
    private func setupNavigationBar() {         // setting up the look and title of the Navigation Bar
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Movie Details"
        setupWatchNavigationButton()
    }
    
    private func setupWatchNavigationButton() { // Creating a Right Navigation Bar
        
       let watchBarButton = UIBarButtonItem(title: "Watch", style: .plain, target: nil, action: nil)
        watchBarButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Avenir-Light", size: 16)!, NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        navigationItem.rightBarButtonItem = watchBarButton
    }
    
    // MARK: Networking - Grabbing images from the database
    private func getImagesAndGenres(){
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
    
    // function to create a viewcontroller hence creating a NowPlayingDetailsViewController
    static func createViewController() -> NowPlayingDetailsViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NowPlayingDetailsViewController") as! NowPlayingDetailsViewController
    }
    
}
