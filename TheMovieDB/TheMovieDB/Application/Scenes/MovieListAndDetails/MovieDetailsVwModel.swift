//
//  MovieDetailsVwModel.swift
//  TheMovieDB
//
//  Created by DS on 16/05/21.
//

import Foundation
import PromiseKit

class MovieDetailsVwModel {
    
    var movieDetails: MovieDetailsResponse?
    
    var movieList = [HomeModel]()
    private let service = FetchMovieServices()
    
    var refreshUI: (() -> ())?
    
    func getMovieDetails(by id: Int, and type: MediaType = .movie) {
        firstly {
            service.fetchMovieDetails(by: id, type: type)
        }.done ({ response in
            if let result = response.result {
                self.movieDetails = result
                //self.refreshUI?()
                self.getAllDetails(by: id)
            }
        }).catch ({ error in
            print("error==========\(error.localizedDescription)")
        })
    }
    
    func getAllDetails(by movieId: Int) {
        firstly {
            when(fulfilled: service.fetchCastAndCrewList(by: movieId),
                 service.fetchTrailerAndVideoList(by: movieId),
                 service.fetchRecommendedMovieList(by: movieId),
                 service.fetchSimilarMovieList(by: movieId)
            )
        }.done ({ crew, trailers, recommended, similar in
            if let crewList = crew.result?.cast, crewList.count != 0 {
                self.movieList.append(HomeModel(sectionName: "Cast & Crew", castAndCrewContent: crewList.filter({ $0.profilePath != nil }), contentType: .castAndCrew))
            }
            if let trailersList = trailers.result?.trailersList, trailersList.count != 0 {
                self.movieList.append(HomeModel(sectionName: "Trailers", trailersContent: trailersList, contentType: .trailers))
            }
            if let recommendedList = recommended.result?.results, recommendedList.count != 0 {
                self.movieList.append(HomeModel(sectionName: "Recommended Movies", content: recommendedList, contentType: .recommended))
            }
            if let similarList = similar.result?.results, similarList.count != 0 {
                self.movieList.append(HomeModel(sectionName: "Similar Movies", content: similarList, contentType: .similar))
            }
            self.refreshUI?()
            
        }).catch ({ error in
            print("error==========\(error.localizedDescription)")
        })
    }
    
    func getVideoForHeader() -> String {
        let trailerList = movieList.filter({ $0.sectionName.lowercased() == "trailers" })
        return trailerList.first?.trailersContent.randomElement()?.key ?? ""
    }
    
    
}
