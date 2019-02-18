//  NowPlayingTableViewController.swift
//  The 10 - George
//  Created by George Garcia on 2/14/19.
//  Copyright © 2019 George Garcia. All rights reserved.

//  Description: NowPlayingTableViewController to display movies that are now playing in theaters!

import UIKit

class NowPlayingTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var dataSource = [Movie]() {
        didSet { tableView.reloadData() }
    }

    let cellID     = "NowPlayingTableViewCell"
    
    // MARK: View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        getNowPlayingMovieData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Here we can check if the user has already seen the Walkthrough Screens
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: TableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {  // we just need only one section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // return the amount of data
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell   = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NowPlayingTableViewCell
        cell.data  = dataSource[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // instead of segues, we can create a ViewController for a specific Movie
        let controller   = NowPlayingDetailsViewController.createViewController()
        controller.movie = dataSource[indexPath.row]
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: Networking - Getting The Data
    
    private func getNowPlayingMovieData() { // Here we can use the generic function to grab data from TheMovieDB NowPlaying API URL
        
        guard let nowPlayingURL = URL(string: now_playingURL) else { return }
        
        NetworkingService.shared.getNowPlayingMovies(with: nowPlayingURL, success: { (data) in
            self.dataSource = data
        }, failure: { error in })
    }
}
