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
            return movieList.count
        } else {
            return 1
        }
    }
    
    func fetchMoviesFor(type: MovieListType = .trending) {
        if !isPaginationNeeded { return }
        //self.isLoading = true
        firstly {
            self.getMoviesRequest(type: type)
        }.done ({ response in
            self.totalPage = response.result?.totalPages ?? 0
            self.currentPage += 1
            //self.isLoading = false
            
            if let movies = response.result?.results, movies.count != 0 {
                self.movieList.append(contentsOf: movies.map({ $0 }).filter({ $0.mediaType != .tv}))
                self.refreshUI?()
            }
        }).catch ({ error in
            self.isLoading = false
            print("error==========\(error.localizedDescription)")
        })
    }
    
    private func getMoviesRequest(type: MovieListType) -> Promise<ResponseModel<MovieListResponse>> {
        switch type {
        case .popular:
            return services.fetchPopularMovieList(for: currentPage)
        case .trending:
            return services.fetchTrendingMovieList(for: currentPage)
        case .topRated:
            return services.fetchTopRatedMovieList(for: currentPage)
        case .kidSpecials:
            return services.fetchKidSpecialMovieList(for: currentPage)
        case .action:
            return services.fetchPopularInActionMovieList(for: currentPage)
        case .thriller:
            return services.fetchPopularInThrillerMovieList(for: currentPage)
        case .horror:
            return services.fetchBestOfHorrorMovieList(for: currentPage)
        case .castAndCrew:
            //return services.fetchCastAndCrewList(by: currentPage)
            return services.fetchBestOfHorrorMovieList(for: currentPage)
        case .trailers:
            //return services.fetchTrailerAndVideoList(by: currentPage)
            return services.fetchBestOfHorrorMovieList(for: currentPage)
        case .recommended:
            return services.fetchRecommendedMovieList(by: currentPage)
        case .similar:
            return services.fetchSimilarMovieList(by: currentPage)
        case .discover:
            return services.fetchDiscoverMovieList(for: currentPage - 1)
        case .upcoming:
            return services.fetchUpcomingMovieList(for: currentPage - 1)
        case .nowPlaying:
            return services.fetchNowPlayingMovieList(by: currentPage - 1)
        }
    }
    
    deinit {
        print("deinited")
    }
    
}
