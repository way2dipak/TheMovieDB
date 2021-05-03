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
    case fetchGenresList
}

extension FetchGenresRequest {
    var route: (method: HTTPMethod, path: String) {
        switch self {
        case .fetchGenresList:
            return (.get, "genre/movie/list?api_key=\(APIKEY)&language=en-US")
        }
    }
}
