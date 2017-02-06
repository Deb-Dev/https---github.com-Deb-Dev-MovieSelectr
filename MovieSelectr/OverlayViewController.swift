//
//  OverlayViewController.swift
//  MovieSelectr
//
//  Created by NXP Tims on 12/01/17.
//  Copyright © 2017 deb. All rights reserved.
//

import UIKit

class OverlayViewController: UIViewController {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    var movieItem : Movie?{
        didSet{
            configureView()
        }
    }
    func configureView()  {
        if let movie = self.movieItem {
            self.titleLable.text = movie.title
            self.descriptionTextView.text = movie.description
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.bounds.size = CGSize(width: UIScreen.main.bounds.size.width - 20, height: 200)
        self.view.layer.cornerRadius = 5
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePressed(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

   
}
