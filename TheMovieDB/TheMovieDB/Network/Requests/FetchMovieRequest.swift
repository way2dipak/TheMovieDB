//
//  FetchMovieRequest.swift
//  TheMovieDB
//
//  Created by DS on 02/05/21.
//

import Foundation
import TheMovieDBNetwork
import PromiseKit
import Alamofire

enum FetchMovieRequest: BaseRequest {
    case fetchTrendingMovieList(Int)
    case fetchPopularMovieList(Int)
    case fetchDiscoverMovieList(Int)
    case fetchTopRatedMovieList(Int)
    case fetchUpComingMovieList(Int)
    case fetchMovieDetailsByID(Int)
}

extension FetchMovieRequest {
    var route: (method: HTTPMethod, path: String) {
        switch self {
        case .fetchDiscoverMovieList(let pageNo):
            return(.get, "discover/movie?api_key=\(APIKEY)&language=en-US&page=\(pageNo)")
        case .fetchPopularMovieList(let pageNo):
            return(.get, "popular/movie?api_key=\(APIKEY)&language=en-US&page=\(pageNo)")
        case .fetchTrendingMovieList(let pageNo):
            return(.get, "trending/movie?api_key=\(APIKEY)&language=en-US&page=\(pageNo)")
        case .fetchTopRatedMovieList(let pageNo):
            return(.get, "top_rated/movie?api_key=\(APIKEY)&language=en-US&page=\(pageNo)")
        case .fetchUpComingMovieList(let pageNo):
            return(.get, "upcoming/movie?api_key=\(APIKEY)&language=en-US&page=\(pageNo)")
        case .fetchMovieDetailsByID(let movieId):
            return(.get, "movie/\(movieId)?api_key=\(APIKEY)&language=en-US")
        }
    }
}
