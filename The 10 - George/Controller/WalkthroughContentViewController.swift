//  WalkthroughContentViewController.swift
//  The 10 - George
//  Created by George Garcia on 2/17/19.
//  Copyright © 2019 George Garcia. All rights reserved.

//  Description: Setting up the WalkthroughViewController's Content

import UIKit
import Lottie

class WalkthroughContentViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var movieReelAnimation: LOTAnimationView!
    
    // MARK: Properties
    var index       = 0
    var heading     = ""
    var subheading  = ""
    var imageFile   = ""

    // MARK: View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIBOutlets()
        startAnimation()
    }
    
    // MARK: UI Customization
    private func setupIBOutlets() {
        headingLabel.text       = heading
        subHeadingLabel.text    = subheading
        contentImageView.image  = UIImage(named: imageFile)
    }
    
    // MARK: Lottie
    private func startAnimation() { // Animation to start
        movieReelAnimation.setAnimation(named: "movie_reel")
        movieReelAnimation.loopAnimation = true
        movieReelAnimation.play()
    }

}
