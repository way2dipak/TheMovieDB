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
    
    func fetchDiscoverMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchDiscoverMovieList(pageNo))
    }
    
    func fetchTrendingMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchTrendingMovieList(pageNo))
    }
    
    func fetchPopularMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchPopularMovieList(pageNo))
    }
    
    func fetchTopRatedMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchTopRatedMovieList(pageNo))
    }
    
    func fetchUpcomingMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchUpComingMovieList(pageNo))
    }
    
    func fetchMovieDetails(by movieId: Int, type: MediaType) -> Promise<ResponseModel<MovieDetailsResponse>> {
        data(FetchMovieRequest.fetchMovieDetailsByID(movieId, type.rawValue))
    }
    
    func fetchKidSpecialMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchKidSpecialMovieList(pageNo))
    }
    
    func fetchPopularInActionMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchActionMovieList(pageNo))
    }
    
    func fetchPopularInThrillerMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchThrillerMovieList(pageNo))
    }
    
    func fetchBestOfHorrorMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchHorrorMovieList(pageNo))
    }
    
    func fetchCastAndCrewList(by movieId: Int) -> Promise<ResponseModel<CaseAndCrewResponseModel>> {
        data(FetchMovieRequest.fetchCastAndCrewList(movieId))
    }
    
    func fetchTrailerAndVideoList(by movieId: Int) -> Promise<ResponseModel<TrailersAndVideoResponseModel>> {
        data(FetchMovieRequest.fetchTrailersList(movieId))
    }
    
    func fetchRecommendedMovieList(by movieId: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchRecommendationMovieList(movieId))
    }
    
    func fetchSimilarMovieList(by movieId: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchSimilarMovieList(movieId))
    }
    
    func fetchNowPlayingMovieList(by pageNo: Int) -> Promise<ResponseModel<MovieListResponse>> {
        data(FetchMovieRequest.fetchNowPlayingMovieList(pageNo))
    }
    
}
