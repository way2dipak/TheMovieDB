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
    
    func fetchDiscoverMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListModel>>
    func fetchTrendingMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListModel>>
    func fetchPopularMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListModel>>
    func fetchTopRatedMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListModel>>
    func fetchUpcomingMovieList(for pageNo: Int) -> Promise<ResponseModel<MovieListModel>>
    func fetchMovieDetails(by movieId: Int) -> Promise<ResponseModel<MovieResultList>>
    
}
