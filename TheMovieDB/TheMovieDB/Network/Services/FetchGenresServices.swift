//
//  FetchGenresServices.swift
//  TheMovieDB
//
//  Created by DS on 03/05/21.
//

import Foundation
import PromiseKit
import TheMovieDBNetwork

class FetchGenresServices: BaseService, GenresListUserCase {
    func fetchGenresList() -> Promise<ResponseModel<GenresModel>> {
        data(FetchGenresRequest.fetchGenresList)
    }
}
