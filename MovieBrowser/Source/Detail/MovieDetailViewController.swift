//
//  MovieDetailViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/26/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
   
    var movie: Movies?
    
    @IBOutlet weak var movieDetail: UITextView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.movieName.text = movie?.originalTitle
        self.releaseDate.text = "Release Date: " + (movie?.releaseDate ?? "N/A")
        self.movieDetail.text = movie?.overview
        if let posterPath = movie?.posterPath {
            movieImage.downloaded(from: posterPath)
        }
    }
}
