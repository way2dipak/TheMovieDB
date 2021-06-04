//
//  MainContainerVC.swift
//  TheMovieDB
//
//  Created by DS on 05/05/21.
//

import UIKit

class MainContainerVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    @IBAction func onTapMenuBtn(_ sender: UIButton) {
        if sender.tag == 0 {
            MovieListNavigator().showMovieListVC(with: [], type: .discover)
        } else if sender.tag == 1 {
            MovieListNavigator().showMovieListVC(with: [], type: .upcoming)
        } else {
            MovieListNavigator().showMovieListVC(with: [], type: .nowPlaying)
        }
    }

}
