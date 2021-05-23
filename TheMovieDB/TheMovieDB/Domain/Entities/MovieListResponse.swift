//
//  MovieListModel.swift
//  TheMovieDB
//
//  Created by DS on 02/05/21.
//

import Foundation

// MARK: - MovieListModel
struct MovieListResponse: Codable {
    let page: Int?
    let results: [MovieResultList]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct MovieResultList: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let name: String?
    let originalName: String?
    let mediaType: MediaType?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case name
        case originalName = "original_name"
        case mediaType = "media_type"
    }
    
    func getMovieName() -> String {
        return title ?? originalTitle ?? name ?? originalName ?? ""
    }
}

enum MediaType: String {
    case movie = "movie"
    case tv = "tv"
}

extension MediaType: Codable {
    public init(from decoder: Decoder) throws {
        self = try MediaType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .movie
    }
}
