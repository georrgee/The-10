//
//  NowPlayingTableViewController.swift
//  The 10 - George
//
//  Created by George Garcia on 2/14/19.
//  Copyright © 2019 George Garcia. All rights reserved.
//

import UIKit

class NowPlayingTableViewController: UITableViewController {
    
    var dataSource = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walktrhoughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
            present(walktrhoughViewController, animated: true, completion: nil)
        }
    }
    
    func getMovieData(){
        
        // use the generics functon for both now playing and upcoming or anythign similar => change and handle errors, responses in 1 place
        
        guard let nowPlayingURL = URL(string: now_playingURL) else { return }
        NetworkingService.shared.getNowPlayingMovies(with: nowPlayingURL, success: { (data) in
            self.dataSource = data
        }, failure: { error in
            // fail action
        })
        
        // testing
//        NetworkingService.shared.getReleaseDate(movieID: "438650", success: { (string) in
//            print("blah, blah")
//        })
        
    }
    
 


    // MARK: - TableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NowPlayingTableViewCell", for: indexPath) as! NowPlayingTableViewCell
        cell.data = dataSource[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = NowPlayingDetailsViewController.createViewController()
        controller.movie = dataSource[indexPath.row]
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
