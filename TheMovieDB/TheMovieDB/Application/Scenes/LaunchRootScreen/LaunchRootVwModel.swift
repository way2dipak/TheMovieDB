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
            service.fetchMovieGenresList()
        }.done ({ movie in
            if let result = movie.result, let genresList = result.genres, genresList.count != 0 {
                SessionManager.shared.geners = result
                onResponse()
            } else {
                onResponse()
            }
        }).catch({ error in
            onResponse()
        })
    }
    
    private func removeDublicates(_ list: [GenresList]) -> [GenresList] {
        return list.sorted(by: { n1, n2 in return (n1.name ?? "").lowercased() != (n2.name ?? "").lowercased() } )
    }
    
}
