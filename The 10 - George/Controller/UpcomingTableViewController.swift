//  UpcomingTableViewController.swift
//  The 10 - George
//  Created by George Garcia on 2/14/19.
//  Copyright © 2019 George Garcia. All rights reserved

//  Description: NowPlayingTableViewController to display movies that are now playing in theaters!

import UIKit

class UpcomingTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var dataSource = [Movie]() {
        didSet { tableView.reloadData() }
    }
    
    let cellID     = "UpcomingTableViewCell"

    // MARK: View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        getUpcomingMovieData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UpcomingTableViewCell
        cell.data = dataSource[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = UpcomingDetailsViewController.createViewController()
        controller.movie = dataSource[indexPath.row]
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: Networking - Getting the data 

    private func getUpcomingMovieData() {
        
        guard let upcomingURL = URL(string: upcoming_URL) else { return }
        
        NetworkingService.shared.getUpcomingMovies(with: upcomingURL, success: { (data) in
            self.dataSource = data
        }, failure: { error in })
    }
}
