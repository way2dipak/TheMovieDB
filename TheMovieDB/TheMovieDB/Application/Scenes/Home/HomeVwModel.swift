//
//  HomeVwModel.swift
//  TheMovieDB
//
//  Created by DS on 11/05/21.
//

import Foundation
import PromiseKit


class HomeVwModel {
    
    var movieList = [HomeModel]()
    var refreshUI: (() -> ())?
    
    private let services = FetchMovieServices()
    
    func loadMovieList() {
        firstly {
            when(fulfilled: services.fetchTrendingMovieList(for: 1),
                 services.fetchPopularMovieList(for: 1),
                 services.fetchTopRatedMovieList(for: 1),
                 services.fetchKidSpecialMovieList(for: 1),
                 services.fetchBestOfHorrorMovieList(for: 1)
            )
        }.done ({ trending, popular, topRated, kidSpecial, horror  in
            self.movieList.append(HomeModel(sectionName: "Top Trending", content: (trending.result?.results ?? []).filter({ $0.mediaType != .tv }), contentType: .trending))
            self.movieList.append(HomeModel(sectionName: "What's Popular", content: (popular.result?.results ?? []).filter({ $0.mediaType != .tv }), contentType: .popular))
            self.movieList.append(HomeModel(sectionName: "Top Rated", content: (topRated.result?.results ?? []).filter({ $0.mediaType != .tv }), contentType: .topRated))
            self.movieList.append(HomeModel(sectionName: "Best of Kids", content: (kidSpecial.result?.results ?? []).filter({ $0.mediaType != .tv }), contentType: .kidSpecials))
            self.movieList.append(HomeModel(sectionName: "Best of Horrors", content: (horror.result?.results ?? []).filter({ $0.mediaType != .tv }), contentType: .horror))
            self.refreshUI?()
        }).catch({ error in
            print("error==========\(error.localizedDescription)")
        })
    }
    
}

