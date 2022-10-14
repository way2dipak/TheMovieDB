//
//  MovieListVwModel.swift
//  TheMovieDB
//
//  Created by DS on 15/05/21.
//

import Foundation
import PromiseKit
import TheMovieDBNetwork

class MovieListVwModel {
    
    private let services = FetchMovieServices()
    var movieList = [MovieResultList]()
    var refreshUI: (() -> ())?
    
    
    var totalPage = 0
    var currentPage = 2
    
    var isLoading = true
    var isPaginationNeeded: Bool {
        get {
            return currentPage != totalPage
        }
    }
    
    func getNumberOfSection() -> Int {
        if isLoading {
            return 2
        } else {
            return 1
        }
    }
    
    func getNumberOfItemsInSection(section: Int) -> Int {
        if section == 0 {
            if movieList.count == 0 {
                return 10
            }
            return movieList.count
        } else {
            return 1
        }
    }
    
    func fetchMoviesFor(type: String) {
        if !isPaginationNeeded { return }
        self.isLoading = true
        firstly {
            services.fetchMovieList(basedOn: type, and: currentPage)
        }.done ({ response in
            if let movies = response.result?.results, movies.count != 0 {
                self.totalPage = response.result?.totalPages ?? 0
                self.currentPage += 1
                self.movieList.append(contentsOf: movies.map({ $0 }).filter({ $0.mediaType != .tv}))
                self.refreshUI?()
            } else {
                self.isLoading = false
                self.refreshUI?()
            }
        }).catch ({ error in
            self.isLoading = false
            self.refreshUI?()
            print("error==========\(error.localizedDescription)")
        })
    }
    
    func fetchMoviesBasedOn(genres: Int) {
        if !isPaginationNeeded { return }
        self.isLoading = true
        firstly {
            services.filterMovie(by: genres, andPageNo: currentPage)
        }.done ({ response in
            if let movies = response.result?.results, movies.count != 0 {
                self.totalPage = response.result?.totalPages ?? 0
                self.currentPage += 1
                self.movieList.append(contentsOf: movies.map({ $0 }).filter({ $0.mediaType != .tv}))
                self.refreshUI?()
            } else {
                self.isLoading = false
                self.refreshUI?()
            }
        }).catch ({ error in
            self.isLoading = false
            self.refreshUI?()
            print("error==========\(error.localizedDescription)")
        })
    }
    
    deinit {
        print("deinited")
    }
    
}
