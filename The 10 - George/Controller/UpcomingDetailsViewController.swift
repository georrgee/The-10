//
//  UpcomingDetailsViewController.swift
//  The 10 - George
//
//  Created by George Garcia on 2/17/19.
//  Copyright © 2019 George Garcia. All rights reserved.
//

import UIKit

class UpcomingDetailsViewController: UIViewController {

    @IBOutlet weak var blurBackgroundImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewView: UIView!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var data: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBlurImage()
        setupIBOutlets()
        setupNavigationBar()
    }
    
    private func setupIBOutlets(){
        movieTitleLabel.text    = data?.title
        releaseDateLabel.text   = data?.releaseDate
        overviewLabel.text      = data?.overView
        
        getImagesFromNetwork()

    }
    
    private func getImagesFromNetwork(){
        if let id = data?.id {
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
        navigationItem.title = "Movie Details"
        setupWatchNavigationButton()
    }
    
    func setupWatchNavigationButton() {
        let watchBarButton = UIBarButtonItem(title: "Watch", style: .plain, target: nil, action: nil)
        //watchBarButton.tintColor = UIColor.white
        watchBarButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Avenir-Light", size: 16)!, NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        navigationItem.rightBarButtonItem = watchBarButton
    }
    
    static func createViewController() -> UpcomingDetailsViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpcomingDetailsViewController") as! UpcomingDetailsViewController
    }
    
}
