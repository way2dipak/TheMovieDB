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
    case fetchMovieGenres
    case fetchTVGenres
    case homeFeeds
    case movieListBasedOn(String, Int)
    case fetchTrendingMovie(Int)
    case fetchUpcomingMovie(Int)
    case fetchBollywoodMovie(Int)
    case fetchPopularMovie(Int)
    case fetchTopRatedMovie(Int)
    case fetchActionMovie(Int)
    case fetchThrillerMovie(Int)
    case fetchKidsMovie(Int)
    case fetchHorrorMovie(Int)
    case fetchComedyMovie(Int)
    case fetchDramaMovie(Int)
    case fetchDocumentryMovie(Int)
    case fetchFamilyMovie(Int)
    case fetchCrimeMovie(Int)
    case fetchRomanceMovie(Int)
    case fetchHistoryMovie(Int)
    case fetchFantasyMovie(Int)
    case fetchMysteryMovie(Int)
    case fetchScifiMovie(Int)
    case fetchTVMovie(Int)
    case fetchWarMovie(Int)
    case fetchWesternMovie(Int)
    case fetchMovieDetailsByID(Int)
    case fetchRecommendedMovieByID(Int, Int)
    case fetchSimilarMoveByID(Int, Int)
    case fetchFilterMovieByGenresID(Int, Int)
    case searchMovieByName(String, Int)
    case searchTVShowsByName(String, Int)
    case fetchStreamingURL
    
}

extension FetchMovieRequest {
    var route: (method: HTTPMethod, path: String) {
        switch self {
        case .fetchMovieGenres:
            return URLRepository.movieGenresList.getURLRequest()
        case .fetchTVGenres:
            return URLRepository.tvGenresList.getURLRequest()
        case .homeFeeds:
            return URLRepository.homeFeeds.getURLRequest()
        case .movieListBasedOn(let sectionName, let pageNo):
            return URLRepository.movieListBasedOn(sectionName, pageNo).getURLRequest()
        case .fetchTrendingMovie(let pageNo):
            return URLRepository.trendingMovie(pageNo).getURLRequest()
        case .fetchUpcomingMovie(let pageNo):
            return URLRepository.upComingMovie(pageNo).getURLRequest()
        case .fetchBollywoodMovie(let pageNo):
            return URLRepository.bollywoodMovie(pageNo).getURLRequest()
        case .fetchPopularMovie(let pageNo):
            return URLRepository.popularMovie(pageNo).getURLRequest()
        case .fetchTopRatedMovie(let pageNo):
            return URLRepository.topRatedMovie(pageNo).getURLRequest()
        case .fetchActionMovie(let pageNo):
            return URLRepository.actionMovie(pageNo).getURLRequest()
        case .fetchThrillerMovie(let pageNo):
            return URLRepository.thrillerMovie(pageNo).getURLRequest()
        case .fetchKidsMovie(let pageNo):
            return URLRepository.kidSpecial(pageNo).getURLRequest()
        case .fetchHorrorMovie(let pageNo):
            return URLRepository.horrorMovie(pageNo).getURLRequest()
        case .fetchComedyMovie(let pageNo):
            return URLRepository.comedyMovie(pageNo).getURLRequest()
        case .fetchDramaMovie(let pageNo):
            return URLRepository.dramaMovie(pageNo).getURLRequest()
        case .fetchDocumentryMovie(let pageNo):
            return URLRepository.documentryMovie(pageNo).getURLRequest()
        case .fetchFamilyMovie(let pageNo):
            return URLRepository.familyMovie(pageNo).getURLRequest()
        case .fetchCrimeMovie(let pageNo):
            return URLRepository.crimeMovie(pageNo).getURLRequest()
        case .fetchRomanceMovie(let pageNo):
            return URLRepository.romanceMovie(pageNo).getURLRequest()
        case .fetchHistoryMovie(let pageNo):
            return URLRepository.historyMovie(pageNo).getURLRequest()
        case .fetchFantasyMovie(let pageNo):
            return URLRepository.fantasyMovie(pageNo).getURLRequest()
        case .fetchMysteryMovie(let pageNo):
            return URLRepository.mysteryMovie(pageNo).getURLRequest()
        case .fetchScifiMovie(let pageNo):
            return URLRepository.scifiMovie(pageNo).getURLRequest()
        case .fetchTVMovie(let pageNo):
            return URLRepository.tvMovies(pageNo).getURLRequest()
        case .fetchWarMovie(let pageNo):
            return URLRepository.warMovie(pageNo).getURLRequest()
        case .fetchWesternMovie(let pageNo):
            return URLRepository.westernMovie(pageNo).getURLRequest()
        case .fetchMovieDetailsByID(let pageNo):
            return URLRepository.movieDetailsByID(pageNo).getURLRequest()
        case .fetchRecommendedMovieByID(let movieId, let pageNo):
            return URLRepository.recommendedMovieByID(movieId, pageNo).getURLRequest()
        case .fetchSimilarMoveByID(let movieId, let pageNo):
            return URLRepository.similarMovieByID(movieId, pageNo).getURLRequest()
        case .fetchFilterMovieByGenresID(let genresId, let pageNo):
            return URLRepository.filterMovieByGenresID(genresId, pageNo).getURLRequest()
        case .searchMovieByName(let query, let pageNo):
            return URLRepository.searchMovie(query, pageNo).getURLRequest()
        case .searchTVShowsByName(let query, let pageNo):
            return URLRepository.searchTV(query, pageNo).getURLRequest()
        case .fetchStreamingURL:
            return URLRepository.streamUrl.getURLRequest()
        }
    }
}

