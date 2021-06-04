//
//  FetchGenresRequest.swift
//  TheMovieDB
//
//  Created by DS on 03/05/21.
//

import Foundation
import TheMovieDBNetwork
import PromiseKit
import Alamofire


enum FetchGenresRequest: BaseRequest {
    case fetchMovieGenresList
    case fetchTVGenreList
}

extension FetchGenresRequest {
    var route: (method: HTTPMethod, path: String) {
        switch self {
        case .fetchMovieGenresList:
            return URLRepository.movieGenresList.getURLRequest()
        case .fetchTVGenreList:
            return URLRepository.tvGenresList.getURLRequest()
        }
    }
}
