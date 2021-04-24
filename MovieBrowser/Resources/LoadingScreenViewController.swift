//
//  LoadingScreenViewController.swift
//  MovieBrowser
//
//  Created by naga vineel golla on 4/23/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation
import UIKit

protocol LoadingScreen where Self: UIViewController {
    var loadingView: LoadingView! { get set }
    func showLoadingScreen()
    func hideLoadingScreen()
}

class LoadingView: UIView {
    var activityIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.activityIndicator = UIActivityIndicatorView.init(style: .large)
        self.backgroundColor = .black
        self.alpha = 0.7
        self.activityIndicator.center = self.center
        self.activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
    }
}

extension LoadingScreen {
    func showLoadingScreen() {
        loadingView = LoadingView(frame: self.view.bounds)
        DispatchQueue.main.async {
            self.view.addSubview(self.loadingView)
        }
    }
    
    func hideLoadingScreen() {
        loadingView.activityIndicator.stopAnimating()
        loadingView.removeFromSuperview()
    }
}
