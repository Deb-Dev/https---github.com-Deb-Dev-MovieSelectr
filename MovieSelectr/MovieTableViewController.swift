//
//  MovieTableViewController.swift
//  MovieSelectr
//
//  Created by NXP Tims on 06/01/17.
//  Copyright © 2017 deb. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    

    var nowPalying = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
            }
    func loadData() {
        Movie.nowPlaying{
            (succes:Bool,moveies : [Movie]?) in
            if succes{
                self.nowPalying = moveies!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nowPalying.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)


        let movie = self.nowPalying[indexPath.row]
        
        cell.textLabel?.text = movie.title
        cell.detailTextLabel?.text = movie.description
        
        Movie.getImageForCell(forCell: cell, withMovieObject: movie)
        
        return cell
    }
    
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
