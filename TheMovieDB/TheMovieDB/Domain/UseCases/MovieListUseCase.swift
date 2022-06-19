//
//  MovieListUseCase.swift
//  TheMovieDB
//
//  Created by DS on 02/05/21.
//

import Foundation
import PromiseKit
import TheMovieDBNetwork

protocol MovieListUseCase {
    func fetchHomeFeeds() -> Promise<ResponseModel<HomeModel>>
    func fetchMovieList(basedOn sectrionName: String, and pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchPopularMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchTrendingMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchTopRatedMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchUpcomingMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchBollywoodMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchComedyMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchDramaMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchDocumentryMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchFamilyMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchCrimeMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchRomanceMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchHistoryMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchFantasyMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchMysteryMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchScifiMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchTVMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchWarMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchWesternMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchKidsMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchActionMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchHorrorMovie(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchRecommendedMovie(for movieId: Int, andPageNo pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchSimilarMovie(for movieId: Int, andPageNo pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func searchMovie(by query: String, for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func searchTv(by query: String, for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchMovieDetails(by movieId: Int) -> Promise<ResponseModel<HomeModel>>
    func filterMovie(by genresId: Int, andPageNo pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    
    func fetchStreamURL(with params: [String: Any]) -> Promise<ResponseModel<VideoResponse>>
    
    
    
}
