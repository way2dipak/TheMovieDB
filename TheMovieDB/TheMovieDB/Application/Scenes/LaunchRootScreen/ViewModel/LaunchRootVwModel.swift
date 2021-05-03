//
//  LaunchRootVwModel.swift
//  TheMovieDB
//
//  Created by DS on 03/05/21.
//

import Foundation
import PromiseKit

class LaunchRootVwModel {
    
    private let service = FetchGenresServices()
    
    func fetchGenresList(onResponse: @escaping () -> Void) {
        firstly {
            self.service.fetchGenresList()
        }.done ({ response in
            if let result = response.result, let genresList = result.genres, genresList.count != 0 {
                SessionManager.shared.geners = result
                onResponse()
            } else {
                onResponse()
            }
        }).catch({ error in
            onResponse()
        })
    }
    
}
