//
//  MovieCollectionViewController.swift
//  MovieSelectr
//
//  Created by NXP Tims on 09/01/17.
//  Copyright © 2017 deb. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MovieCollectionViewController: UICollectionViewController {

    var nowPalying = [Movie]()
    
    let movieTransitionDelegate = MovieTransitionDelegate()
    
    
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
                    self.collectionView!.reloadData()
                }
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPalying.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showOverLayFor(indexPath: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
        let movie = nowPalying[indexPath.row]
        cell.movieTitle.text = movie.title
        Movie.getImageForCell(forCell: cell, withMovieObject: movie)
        
    
        // Configure the cell
    
        return cell
    }
    func showOverLayFor(indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let overLayVC = sb.instantiateViewController(withIdentifier: "Overlay") as! OverlayViewController
        transitioningDelegate = movieTransitionDelegate
        overLayVC.transitioningDelegate = movieTransitionDelegate
        overLayVC.modalPresentationStyle = .custom
        
        let movie = nowPalying[indexPath.row]
        
        self.present(overLayVC, animated: true, completion: nil)
        overLayVC.movieItem = movie
        
        
        
    }
}
