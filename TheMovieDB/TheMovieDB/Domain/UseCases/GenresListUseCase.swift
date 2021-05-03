//
//  GenresListUseCase.swift
//  TheMovieDB
//
//  Created by DS on 03/05/21.
//

import Foundation
import PromiseKit
import TheMovieDBNetwork

protocol GenresListUserCase {
    func fetchGenresList() -> Promise<ResponseModel<GenresModel>>
}
