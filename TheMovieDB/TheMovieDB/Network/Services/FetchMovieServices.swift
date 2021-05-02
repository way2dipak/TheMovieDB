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
    
    func fetchDiscoverMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListModel>> {
        data(FetchMovieRequest.fetchDiscoverMovieList(pageNo))
    }
    
    func fetchTrendingMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListModel>> {
        data(FetchMovieRequest.fetchTrendingMovieList(pageNo))
    }
    
    func fetchPopularMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListModel>> {
        data(FetchMovieRequest.fetchPopularMovieList(pageNo))
    }
    
    func fetchTopRatedMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListModel>> {
        data(FetchMovieRequest.fetchTopRatedMovieList(pageNo))
    }
    
    func fetchUpcomingMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListModel>> {
        data(FetchMovieRequest.fetchUpComingMovieList(pageNo))
    }
    
    func fetchMovieDetails(by movieId: Int) -> Promise<ResponseModel<MovieResultList>> {
        data(FetchMovieRequest.fetchMovieDetailsByID(movieId))
    }
    
}
