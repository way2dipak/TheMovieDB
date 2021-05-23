//
//  HomeModel.swift
//  TheMovieDB
//
//  Created by DS on 11/05/21.
//

import Foundation

struct HomeModel {
    let sectionName: String
    var content: [MovieResultList] = []
    var castAndCrewContent: [Cast] = []
    var trailersContent: [TrailersList] = []
    var contentType: MovieListType = .popular
}

enum MovieListType: String {
    case trending = "Top Trending"
    case popular = "What's Popular"
    case topRated = "Top Rated"
    case upcoming = "Upcoming Movies"
    case kidSpecials = "Best of Kids"
    case action = "Popular in Action"
    case thriller = "Popular in Thriller"
    case horror = "Best of Horrors"
    case castAndCrew = "Cast & Crew"
    case trailers = "More Videos"
    case recommended = "Recommended Movies"
    case similar = "Similar Movies"
    case discover = "Discover"
    case nowPlaying = "Now Playing"
}
