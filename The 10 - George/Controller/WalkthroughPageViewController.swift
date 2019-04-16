//  WalkthroughPageViewController.swift
//  The 10 
//  Created by George Garcia on 2/17/19.
//  Copyright © 2019 George Garcia. All rights reserved.

//  Descriptiopn: Setting up the Walkthrough

import UIKit

protocol WalkthroughPageViewControllerDelegate: class { // protocol we can use so we can update the page control UI
    func didUpdatePageIndex(currentIndex: Int)
}

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: Properties
    var pageHeadings    = ["MOVIES NOW", "MOVIE DETAILS", "MOVIES COMING SOON"]
    var pageImages      = ["now_playing_image", "now_playing_details_image", "upcoming_image"]
    var pageSubHeadings = ["Have the power to see movies that are now playing in theaters!", "Check out more details of a movie!", "Get ot know what movies are coming out in the future!"]
    var currentIndex    = 0
    
    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate?
    
    // MARK: View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        //Create the first walkthrough screen
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        
        return contentViewController(at: index)
    }
    
    // MARK: HELPER
    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            pageContentViewController.imageFile     = pageImages[index]
            pageContentViewController.heading       = pageHeadings[index]
            pageContentViewController.subheading    = pageSubHeadings[index]
            pageContentViewController.index         = index
            
            return pageContentViewController
        }
        return nil
    }
    
    func fowardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {
                currentIndex = contentViewController.index
                walkthroughDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
    }
    
}
