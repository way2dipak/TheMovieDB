//
//  URLRepository.swift
//  TheMovieDB
//
//  Created by DS on 15/05/21.
//

import Foundation
import Alamofire


enum URLRepository {
    
    case movieGenresList
    case tvGenresList
    case discoverMovie(Int)
    case popularMovie(Int)
    case trendingMovie(Int)
    case topRatedMovie(Int)
    case upComingMovie(Int)
    case kidSpecial(Int)
    case movieDetailsById(Int, String)
    case actionMovie(Int)
    case thrillerMovie(Int)
    case horrorMovie(Int)
    case castAndCrew(Int)
    case movieTrailers(Int)
    case movieRecommendation(Int)
    case movieSimilar(Int)
    case nowPlaying(Int)
    case streamUrl
    
    func getURLRequest() -> (HTTPMethod, String) {
        switch self {
        case .movieGenresList:
            return (.get, "genre/movie/list?api_key=\(APIKEY)&language=en-US")
        case .tvGenresList:
            return (.get, "genre/tv/list?api_key=\(APIKEY)&language=en-US")
        case .discoverMovie(let pageNo):
            return (.get, "discover/movie?api_key=\(APIKEY)&language=en-US&page=\(pageNo)")
        case .popularMovie(let pageNo):
            return (.get, "movie/popular?api_key=\(APIKEY)&language=en-US&page=\(pageNo)")
        case .trendingMovie(let pageNo):
            return(.get, "trending/all/day?api_key=\(APIKEY)&language=en-US&page=\(pageNo)")
        case .topRatedMovie(let pageNo):
            return(.get, "movie/top_rated?api_key=\(APIKEY)&language=en-US&page=\(pageNo)")
        case .upComingMovie(let pageNo):
            return(.get, "movie/upcoming?api_key=\(APIKEY)&language=en-US&page=\(pageNo)")
        case .kidSpecial(let pageNo):
            return(.get, "discover/movie?api_key=\(APIKEY)&language=en-US&with_genres=16&page=\(pageNo)")
        case .movieDetailsById(let movieId, let type):
            return(.get, "\(type)/\(movieId)?api_key=\(APIKEY)&language=en-US")
        case .actionMovie(let pageNo):
            return(.get, "discover/movie?api_key=\(APIKEY)&language=en-US&with_genres=28&page=\(pageNo)")
        case .thrillerMovie(let pageNo):
            return(.get, "discover/movie?api_key=\(APIKEY)&language=en-US&with_genres=53&page=\(pageNo)")
        case .horrorMovie(let pageNo):
            return(.get, "discover/movie?api_key=\(APIKEY)&language=en-US&with_genres=27&page=\(pageNo)")
        case .castAndCrew(let movieId):
            return(.get, "movie/\(movieId)/credits?api_key=\(APIKEY)&language=en-US")
        case .movieTrailers(let movieId):
            return(.get, "movie/\(movieId)/videos?api_key=\(APIKEY)&language=en-US")
        case .movieRecommendation(let movieId):
            return(.get, "movie/\(movieId)/recommendations?api_key=\(APIKEY)&language=en-US")
        case .movieSimilar(let movieId):
            return(.get, "movie/\(movieId)/similar?api_key=\(APIKEY)&language=en-US")
        case .nowPlaying(let pageNo):
            return(.get, "movie/now_playing?api_key=\(APIKEY)&language=en-US&page=\(pageNo)")
        case .streamUrl:
            return(.post, "youtubei/v1/player?key=AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8")
        }
    }
    
}
