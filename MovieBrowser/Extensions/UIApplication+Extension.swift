//
//  UIApplication+Extension.swift
//  MovieBrowser
//
//  Created by naga vineel golla on 4/23/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func getPresentedVC() -> UIViewController? {
        let presentedVC = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        return presentedVC?.rootViewController
    }
}
