//
//  UIImageView+Extension.swift
//  MovieBrowser
//
//  Created by naga vineel golla on 4/23/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from link: String) {
        let imageUrl = Constants.imageUrl + link
        guard let url = URL(string: imageUrl) else { return }
        
        if let data = try? Data(contentsOf: url) {
            self.image = UIImage(data: data)
        }
    }
}
