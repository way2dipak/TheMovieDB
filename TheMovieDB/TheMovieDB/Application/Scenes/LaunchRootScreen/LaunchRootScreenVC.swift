//
//  ViewController.swift
//  TheMovieDB
//
//  Created by DS on 02/05/21.
//

import UIKit
import TheMovieDBPersistence

class LaunchRootScreenVC: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private let vwModel = LaunchRootVwModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGenres()
    }
    
    func fetchGenres() {
        spinner.startAnimating()
        vwModel.fetchGenresList(onResponse: { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                BaseNavigator().showTabBarVC()
            }
        })
    }
    
}

