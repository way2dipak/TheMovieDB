//
//  HomeVwModel.swift
//  TheMovieDB
//
//  Created by DS on 11/05/21.
//

import Foundation
import PromiseKit


class HomeVwModel {
    
    var movieList = [HomeList]()
    var refreshUI: (() -> ())?
    
    private var service = FetchMovieServices()
    
    func loadMovieList() {
        firstly {
            self.service.fetchHomeFeeds()
        }.done ({ results in
            if let feeds = results.result, feeds.success ?? false {
                self.movieList = feeds.results ?? []
            }
            self.refreshUI?()
        }).catch({ error in
            print("error==========\(error.localizedDescription)")
        })
    }
    
    func getRandomMovie() -> MovieResultList? {
        return movieList.filter({ $0.contentType != .exploreByGenres }).randomElement()?.sectionData?.randomElement() ?? nil
    }
    
    deinit {
        print("deinited")
    }
    
}

