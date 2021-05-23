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
    
    func fetchTrendingMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchPopularMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchTopRatedMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchMovieDetails(by movieId: Int, type: MediaType) -> Promise<ResponseModel<MovieDetailsResponse>>
    func fetchKidSpecialMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchPopularInActionMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchPopularInThrillerMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchBestOfHorrorMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    
    func fetchCastAndCrewList(by movieId: Int) -> Promise<ResponseModel<CaseAndCrewResponseModel>>
    func fetchTrailerAndVideoList(by movieId: Int) -> Promise<ResponseModel<TrailersAndVideoResponseModel>>
    func fetchRecommendedMovieList(by movieId: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchSimilarMovieList(by movieId: Int) -> Promise<ResponseModel<MovieListResponse>>
    
    func fetchDiscoverMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchUpcomingMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchNowPlayingMovieList(by pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    
    
    
}
