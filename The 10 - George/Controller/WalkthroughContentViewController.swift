//
//  WalkthroughContentViewController.swift
//  The 10 - George
//
//  Created by George Garcia on 2/17/19.
//  Copyright © 2019 George Garcia. All rights reserved.
//

import UIKit
import Lottie

class WalkthroughContentViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var movieReelAnimation: LOTAnimationView!
    
    var index       = 0
    var heading     = ""
    var subheading  = ""
    var imageFile   = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        headingLabel.text = heading
        subHeadingLabel.text = subheading
        contentImageView.image = UIImage(named: imageFile)
        startAnimation()
    }
    
    func startAnimation() {
        movieReelAnimation.setAnimation(named: "movie_reel")
        movieReelAnimation.loopAnimation = true
        movieReelAnimation.play()
    }

}
