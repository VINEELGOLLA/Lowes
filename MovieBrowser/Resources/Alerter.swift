//
//  Alerter.swift
//  MovieBrowser
//
//  Created by naga vineel golla on 4/23/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation
import UIKit

protocol Alerter {
    func alert(error: Error)
}

extension Alerter {
    func alert(error: Error) {
        var title = "Error"
        var message = error.localizedDescription
        let cancelAction = UIAlertAction(title: "Okay", style: .cancel)

        
        if let movieError = error as? MbError {
            message = movieError.message
            title = movieError.title
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(cancelAction)
        
        UIApplication.getPresentedVC()?.present(alert, animated: true, completion: nil)
    }
}
