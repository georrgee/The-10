//  UpcomingTableViewController.swift
//  The 10 - George
//  Created by George Garcia on 2/14/19.
//  Copyright © 2019 George Garcia. All rights reserved.

import UIKit

class UpcomingTableViewController: UITableViewController {
    
    var dataSource = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getUpcomingMovieData()
    }
    
    func getUpcomingMovieData() {
        
        guard let upcomingURL = URL(string: upcoming_URL) else { return }
        
        NetworkingService.shared.getUpcomingMovies(with: upcomingURL, success: { (data) in
            self.dataSource = data
        }, failure: { error in
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "UpcomingTableViewCell", for: indexPath) as! UpcomingTableViewCell
        cell.data = dataSource[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = UpcomingDetailsViewController.createViewController()
        controller.data = dataSource[indexPath.row]
        
        navigationController?.pushViewController(controller, animated: true)
    }

    
}
