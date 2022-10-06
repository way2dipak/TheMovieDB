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
    case homeFeeds
    case movieListBasedOn(String, Int)
    case popularMovie(Int)
    case trendingMovie(Int)
    case topRatedMovie(Int)
    case upComingMovie(Int)
    case bollywoodMovie(Int)
    case comedyMovie(Int)
    case dramaMovie(Int)
    case documentryMovie(Int)
    case familyMovie(Int)
    case crimeMovie(Int)
    case romanceMovie(Int)
    case historyMovie(Int)
    case fantasyMovie(Int)
    case mysteryMovie(Int)
    case scifiMovie(Int)
    case tvMovies(Int)
    case warMovie(Int)
    case westernMovie(Int)
    case kidSpecial(Int)
    case actionMovie(Int)
    case thrillerMovie(Int)
    case horrorMovie(Int)
    case recommendedMovieByID(Int, Int)
    case similarMovieByID(Int, Int)
    case streamUrl
    case searchMovie(String, Int)
    case searchTV(String, Int)
    case movieDetailsByID(Int)
    case filterMovieByGenresID(Int, Int)
    
    func getURLRequest() -> (HTTPMethod, String) {
        switch self {
        case .movieGenresList:
            return (.get, "genre/movie")
        case .tvGenresList:
            return (.get, "genre/tv")
        case .homeFeeds:
            return (.get, "movie/feed")
        case .movieListBasedOn(let sectionName, let pageNo):
            return (.get, "movie/\(sectionName)/\(pageNo)")
        case .popularMovie(let pageNo):
            return (.get, "movie/popular/\(pageNo)")
        case .trendingMovie(let pageNo):
            return (.get, "movie/trending/\(pageNo)")
        case .topRatedMovie(let pageNo):
            return (.get, "movie/toprated/\(pageNo)")
        case .upComingMovie(let pageNo):
            return (.get, "movie/upcoming/\(pageNo)")
        case .bollywoodMovie(let pageNo):
            return (.get, "movie/bollywood/\(pageNo)")
        case .comedyMovie(let pageNo):
            return (.get, "movie/comedy/\(pageNo)")
        case .dramaMovie(let pageNo):
            return (.get, "movie/drama/\(pageNo)")
        case .documentryMovie(let pageNo):
            return (.get, "movie/documentry/\(pageNo)")
        case .familyMovie(let pageNo):
            return (.get, "movie/family/\(pageNo)")
        case .crimeMovie(let pageNo):
            return (.get, "movie/crime/\(pageNo)")
        case .romanceMovie(let pageNo):
            return (.get, "movie/romance/\(pageNo)")
        case .historyMovie(let pageNo):
            return (.get, "movie/history/\(pageNo)")
        case .fantasyMovie(let pageNo):
            return (.get, "movie/fantasy/\(pageNo)")
        case .mysteryMovie(let pageNo):
            return (.get, "movie/mystery/\(pageNo)")
        case .scifiMovie(let pageNo):
            return (.get, "movie/scifi/\(pageNo)")
        case .tvMovies(let pageNo):
            return (.get, "movie/tvmovie/\(pageNo)")
        case .warMovie(let pageNo):
            return (.get, "movie/war/\(pageNo)")
        case .westernMovie(let pageNo):
            return (.get, "movie/western/\(pageNo)")
        case .kidSpecial(let pageNo):
            return (.get, "movie/kids/\(pageNo)")
        case .actionMovie(let pageNo):
            return (.get, "movie/action/\(pageNo)")
        case .thrillerMovie(let pageNo):
            return (.get, "movie/thriller/\(pageNo)")
        case .horrorMovie(let pageNo):
            return (.get, "movie/horror/\(pageNo)")
        case .recommendedMovieByID(let movieId, let pageNo):
            return (.get, "movie/\(movieId)/recommendedmovies/\(pageNo)")
        case .similarMovieByID(let movieId, let pageNo):
            return (.get, "movie/\(movieId)/similarmovies/\(pageNo)")
        case .streamUrl:
            return(.post, "youtubei/v1/player?key=AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8")
        case .searchMovie(let query, let pageNo):
            return (.get, "search/movie/\(query)/\(pageNo)")
        case .searchTV(let query, let pageNo):
            return (.get, "search/tv/\(query)/\(pageNo)")
        case .movieDetailsByID(let movieId):
            return (.get, "movie/moviedetailbyid/\(movieId)")
        case .filterMovieByGenresID(let genresId, let pageNo):
            return (.get, "movie/filter/\(genresId)/\(pageNo)")
        }
    }
    
}
