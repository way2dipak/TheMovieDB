//
//  HomeModel.swift
//  TheMovieDB
//
//  Created by DS on 11/05/21.
//

import Foundation

struct HomeModel: Codable {
    let status: Int?
    let success: Bool?
    let results: [HomeList]?
}

struct HomeList: Codable {
    let index: Int?
    let sectionTitle: String?
    let sectionData: [MovieResultList]?
    
    var contentType: SectionType  {
        get {
            return SectionType.contentType(type: sectionTitle?.lowercased() ?? "")
        }
    }
}

enum SectionType: String {
    case exploreByGenres = "explore by genres"
    case header = "header"
    case castAndCrew = "cast & crew"
    case trailers = "trailers"
    case carousels = "carousels"
    case topTrending = "top trending"
    case popularMovie = "Popular Movies"
    case topRated = "top rated"
    case action = "action movies"
    case comedy = "comedy movies"
    case drama = "drama"
    case documentary = "documentary"
    case familyMovie = "family movies"
    case crime = "crime"
    case romance = "romance movies"
    case history = "history"
    case thriller = "thriller movies"
    case bollywood = "movies in hindi"
    case kids = "best of kids"
    case horror = "horrors"
    case fantasy = "fantasy movies"
    case mystery = "mystery"
    case scifi = "sci-fi movies"
    case bestInTV = "best in tv"
    case war = "war"
    case westernMovies = "western movies"
    
    static func contentType(type: String) -> SectionType {
        switch type {
        case "explore by genres":
            return .exploreByGenres
        case "header":
            return .header
        case "cast & crew":
            return .castAndCrew
        case "trailers":
            return .trailers
        default:
            return .carousels
        }
    }
}


