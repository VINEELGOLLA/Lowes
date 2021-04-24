//
//  SearchViewTableViewCell.swift
//  MovieBrowser
//
//  Created by naga vineel golla on 4/23/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation
import UIKit

class SearchViewTableViewCell: UITableViewCell {
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    
    override func prepareForReuse() {
        movieName.text = ""
        movieDate.text = ""
        movieRating.text = ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
}
