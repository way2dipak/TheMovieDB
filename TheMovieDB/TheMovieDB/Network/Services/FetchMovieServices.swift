//
//  FetchMovieServices.swift
//  TheMovieDB
//
//  Created by DS on 02/05/21.
//

import Foundation
import TheMovieDBNetwork
import PromiseKit
import Alamofire


class FetchMovieServices: BaseService, MovieListUseCase {
    func fetchHomeFeeds() -> Promise<ResponseModel<HomeModel>> {
        data(FetchMovieRequest.homeFeeds)
    }
    
    func fetchMovieList(basedOn sectrionName: String, and pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.movieListBasedOn(sectrionName, pageNo))
    }
    
    func fetchPopularMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchPopularMovie(pageNo))
    }
    
    func fetchTrendingMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchTrendingMovie(pageNo))
    }
    
    func fetchTopRatedMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchTopRatedMovie(pageNo))
    }
    
    func fetchUpcomingMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchUpcomingMovie(pageNo))
    }
    
    func fetchBollywoodMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchBollywoodMovie(pageNo))
    }
    
    func fetchComedyMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchComedyMovie(pageNo))
    }
    
    func fetchDramaMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchDramaMovie(pageNo))
    }
    
    func fetchDocumentryMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchDocumentryMovie(pageNo))
    }
    
    func fetchFamilyMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchFamilyMovie(pageNo))
    }
    
    func fetchCrimeMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchCrimeMovie(pageNo))
    }
    
    func fetchRomanceMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchRomanceMovie(pageNo))
    }
    
    func fetchHistoryMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchHistoryMovie(pageNo))
    }
    
    func fetchFantasyMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchFantasyMovie(pageNo))
    }
    
    func fetchMysteryMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchMysteryMovie(pageNo))
    }
    
    func fetchScifiMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchScifiMovie(pageNo))
    }
    
    func fetchTVMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchTVMovie(pageNo))
    }
    
    func fetchWarMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchWarMovie(pageNo))
    }
    
    func fetchWesternMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchWesternMovie(pageNo))
    }
    
    func fetchKidsMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchKidsMovie(pageNo))
    }
    
    func fetchActionMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchActionMovie(pageNo))
    }
    
    func fetchHorrorMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchHorrorMovie(pageNo))
    }
    
    func fetchRecommendedMovie(for movieId: Int, andPageNo pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchRecommendedMovieByID(movieId, pageNo))
    }
    
    func fetchSimilarMovie(for movieId: Int, andPageNo pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchSimilarMoveByID(movieId, pageNo))
    }
    
    func searchMovie(by query: String, for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.searchMovieByName(query, pageNo))
    }
    
    func searchTv(by query: String, for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.searchTVShowsByName(query, pageNo))
    }
    
    func fetchMovieDetails(by movieId: Int) -> Promise<ResponseModel<HomeModel>> {
        data(FetchMovieRequest.fetchMovieDetailsByID(movieId))
    }
    
    func filterMovie(by genresId: Int, andPageNo pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchFilterMovieByGenresID(genresId, pageNo))
    }
    
    func fetchStreamURL(with params: [String : Any]) -> Promise<ResponseModel<VideoResponse>> {
        data(FetchMovieRequest.fetchStreamingURL, parameters: params, baseUrl: "https://www.youtube.com/")
    }
}

