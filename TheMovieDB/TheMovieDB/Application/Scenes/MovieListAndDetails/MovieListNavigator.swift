//
//  MovieListNavigator.swift
//  TheMovieDB
//
//  Created by DS on 15/05/21.
//

import Foundation
import UIKit


class MovieListNavigator {
    
    private let storyboard = UIStoryboard(name: "MovieDetails", bundle: nil)
    
    func showMovieListVC(with movieList: [MovieResultList], type: MovieListType) {
        let vc = storyboard.instantiateViewController(withIdentifier: MovieListVC.identifier) as! MovieListVC
        vc.vwModel.movieList = movieList
        vc.type = type
        AppDelegate.shared.push(to: vc, animated: true)
        
    }
    
    func showMovieDetailsVC(with movieId: Int, type: MediaType) {
        let vc = storyboard.instantiateViewController(withIdentifier: MovieDetilsVC.identifier) as! MovieDetilsVC
        vc.movieID = movieId
        vc.loadDetails(movieId: movieId, type: type)
        AppDelegate.shared.push(to: vc, animated: true)
        
    }
    
}
