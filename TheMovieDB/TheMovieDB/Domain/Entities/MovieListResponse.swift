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
    let budget: Int?
    let genres: [GenresList]?
    let homepage: String?
    let id: Int?
    let videoId: String?
    let imdbID: String?
    let originalLanguage: String?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    
    let releaseDate: String?
    let revenue, runtime: Int?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount, gender: Int?
    let name, originalName: String?
    let profilePath: String?
    let castID: Int?
    let character, creditID: String?
    let order: Int?
    let key, site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let publishedAt: String?
    let genreIDS: [Int]?
    let mediaType: MediaType?
    let background: String?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget, genres, homepage, id
        case videoId
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case revenue, runtime
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case gender
        case name
        case originalName = "original_name"
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order
        case key, site, size, type, official
        case publishedAt = "published_at"
        case genreIDS = "genre_ids"
        case mediaType = "media_type"
        case background
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.videoId = try? container.decodeIfPresent(String.self, forKey: .videoId) ?? ""
        self.adult = try container.decodeIfPresent(Bool.self, forKey: .adult) ?? false
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) ?? ""
        self.budget = try container.decodeIfPresent(Int.self, forKey: .budget) ?? 0
        self.genres = try container.decodeIfPresent([GenresList].self, forKey: .genres) ?? []
        self.homepage = try container.decodeIfPresent(String.self, forKey: .homepage) ?? ""
        self.imdbID = try container.decodeIfPresent(String.self, forKey: .imdbID) ?? ""
        self.originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage) ?? ""
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle) ?? nil
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity) ?? 0
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? ""
        
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        self.revenue = try container.decodeIfPresent(Int.self, forKey: .revenue) ?? 0
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime) ?? 0
        self.status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? nil
        self.video = try container.decodeIfPresent(Bool.self, forKey: .video) ?? false
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount) ?? 0
        self.gender = try container.decodeIfPresent(Int.self, forKey: .gender) ?? 0
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? nil
        self.originalName = try container.decodeIfPresent(String.self, forKey: .originalName) ?? nil
        self.profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath) ?? ""
        self.castID = try container.decodeIfPresent(Int.self, forKey: .castID) ?? 0
        self.character = try container.decodeIfPresent(String.self, forKey: .character) ?? ""
        self.creditID = try container.decodeIfPresent(String.self, forKey: .creditID) ?? ""
        self.order = try container.decodeIfPresent(Int.self, forKey: .order) ?? 0
        self.key = try container.decodeIfPresent(String.self, forKey: .key) ?? ""
        self.site = try container.decodeIfPresent(String.self, forKey: .site) ?? ""
        self.size = try container.decodeIfPresent(Int.self, forKey: .size) ?? 0
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.official = try container.decodeIfPresent(Bool.self, forKey: .official) ?? false
        self.publishedAt = try container.decodeIfPresent(String.self, forKey: .publishedAt) ?? ""
        self.genreIDS = try container.decodeIfPresent([Int].self, forKey: .genreIDS) ?? []
        self.mediaType = try container.decodeIfPresent(MediaType.self, forKey: .mediaType) ?? .movie
        self.background = try container.decodeIfPresent(String.self, forKey: .background) ?? ""
    }
    
    func getMovieName() -> String {
        return title ?? originalTitle ?? name ?? originalName ?? ""
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int?
    let name: String?
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
}
