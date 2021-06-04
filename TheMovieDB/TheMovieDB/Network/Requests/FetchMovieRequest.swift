//
//  FetchMovieRequest.swift
//  TheMovieDB
//
//  Created by DS on 02/05/21.
//

import Foundation
import TheMovieDBNetwork
import Alamofire

enum FetchMovieRequest: BaseRequest {
    case fetchTrendingMovieList(Int)
    case fetchPopularMovieList(Int)
    case fetchDiscoverMovieList(Int)
    case fetchTopRatedMovieList(Int)
    case fetchUpComingMovieList(Int)
    case fetchMovieDetailsByID(Int, String)
    case fetchKidSpecialMovieList(Int)
    case fetchActionMovieList(Int)
    case fetchThrillerMovieList(Int)
    case fetchHorrorMovieList(Int)
    case fetchCastAndCrewList(Int)
    case fetchTrailersList(Int)
    case fetchRecommendationMovieList(Int)
    case fetchSimilarMovieList(Int)
    case fetchNowPlayingMovieList(Int)
    
}

extension FetchMovieRequest {
    var route: (method: HTTPMethod, path: String) {
        switch self {
        case .fetchDiscoverMovieList(let pageNo):
            return URLRepository.discoverMovie(pageNo).getURLRequest()
        case .fetchPopularMovieList(let pageNo):
            return URLRepository.popularMovie(pageNo).getURLRequest()
        case .fetchTrendingMovieList(let pageNo):
            return URLRepository.trendingMovie(pageNo).getURLRequest()
        case .fetchTopRatedMovieList(let pageNo):
            return URLRepository.topRatedMovie(pageNo).getURLRequest()
        case .fetchUpComingMovieList(let pageNo):
            return URLRepository.upComingMovie(pageNo).getURLRequest()
        case .fetchMovieDetailsByID(let movieId, let type):
            return URLRepository.movieDetailsById(movieId, type).getURLRequest()
        case .fetchKidSpecialMovieList(let pageNo):
            return URLRepository.kidSpecial(pageNo).getURLRequest()
        case .fetchActionMovieList(let pageNo):
            return URLRepository.actionMovie(pageNo).getURLRequest()
        case .fetchThrillerMovieList(let pageNo):
            return URLRepository.thrillerMovie(pageNo).getURLRequest()
        case .fetchHorrorMovieList(let pageNo):
            return URLRepository.horrorMovie(pageNo).getURLRequest()
        case .fetchCastAndCrewList(let movieId):
            return URLRepository.castAndCrew(movieId).getURLRequest()
        case .fetchTrailersList(let movieId):
            return URLRepository.movieTrailers(movieId).getURLRequest()
        case .fetchRecommendationMovieList(let movieId):
            return URLRepository.movieRecommendation(movieId).getURLRequest()
        case .fetchSimilarMovieList(let movieId):
            return URLRepository.movieSimilar(movieId).getURLRequest()
        case .fetchNowPlayingMovieList(let pageNo):
            return URLRepository.nowPlaying(pageNo).getURLRequest()
        }
    }
}
