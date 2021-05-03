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
    
    func fetchDiscoverMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchTrendingMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchPopularMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchTopRatedMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchUpcomingMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListResponse>>
    func fetchMovieDetails(by movieId: Int) -> Promise<ResponseModel<MovieResultList>>
    
}
