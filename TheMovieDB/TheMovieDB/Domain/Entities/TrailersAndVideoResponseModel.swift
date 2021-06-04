//
//  TrailersAndVideoResponseModel.swift
//  TheMovieDB
//
//  Created by DS on 18/05/21.
//

import Foundation

struct TrailersAndVideoResponseModel: Codable {
    let id: Int?
    let trailersList: [TrailersList]?
    enum CodingKeys: String, CodingKey {
     case id
    case trailersList = "results"
    }
}

// MARK: - Result
struct TrailersList: Codable {
    let id, iso639_1, iso3166_1, key: String?
    let name, site: String?
    let size: Int?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case key, name, site, size, type
    }
}
