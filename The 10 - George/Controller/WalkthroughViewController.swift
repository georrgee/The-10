//  WalkthroughViewController.swift
//  The 10 - George
//  Created by George Garcia on 2/17/19.
//  Copyright © 2019 George Garcia. All rights reserved.

//  Description: Walkthrough with its UIButtons and View

import UIKit

class WalkthroughViewController: UIViewController, WalkthroughPageViewControllerDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton:  UIButton! {
        didSet {
            nextButton.layer.cornerRadius   = 25.0
            nextButton.layer.masksToBounds  = true
        }
    }
    
    @IBOutlet weak var skipButton: UIButton!
    
    // MARK: Properties
    var walkthroughPageViewController: WalkthroughPageViewController?
    
    // MARK: IBActions
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
                
            case 0...1:
                walkthroughPageViewController?.fowardPage()
                
            case 2:
                UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil)
                
            default: break
            }
        }
        updateUI()
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UI Updates
    
    func updateUI() {
        
        if let index = walkthroughPageViewController?.currentIndex {
            
            switch index {
                
            case 0...1:
                nextButton.setTitle("NEXT", for: .normal)
                skipButton.isHidden = false
            case 2:
                
                nextButton.setTitle("GET STARTED", for: .normal)
                skipButton.isHidden = true
            default: break
            }
            pageControl.currentPage = index
        }
    }
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Prepare Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination
        
            if let pageViewController = destination as? WalkthroughPageViewController {
                
                walkthroughPageViewController = pageViewController
                walkthroughPageViewController?.walkthroughDelegate = self
            }
    }
}
