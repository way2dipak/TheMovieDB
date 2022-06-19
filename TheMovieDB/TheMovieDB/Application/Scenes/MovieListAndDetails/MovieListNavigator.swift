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
    private let player = UIStoryboard(name: "VideoPlayer", bundle: nil)
    
    func showMovieListVC(with movieList: [MovieResultList], type: SectionType, sectionName: String = "") {
        let vc = storyboard.instantiateViewController(withIdentifier: MovieListVC.identifier) as! MovieListVC
        vc.vwModel.movieList = movieList
        vc.type = type
        vc.sectionName = sectionName
        AppDelegate.shared.push(to: vc, animated: true)
    }
    
    func showMovieDetailsVC(with movieId: Int, type: MediaType) {
        let vc = storyboard.instantiateViewController(withIdentifier: MovieDetilsVC.identifier) as! MovieDetilsVC
        vc.movieID = movieId
        vc.type = type
        AppDelegate.shared.push(to: vc, animated: true)
    }
    
    func showVideoPlayerVC(with details: MovieDetailsResponse?, videoID: String, videoList: [TrailersList]) {
        let vc = player.instantiateViewController(withIdentifier: VideoPlayerVC.identifier) as! VideoPlayerVC
        vc.details = details
        vc.videoId = videoID
        vc.movieList = videoList
        AppDelegate.shared.push(to: vc, animated: true)
    }
    
}
