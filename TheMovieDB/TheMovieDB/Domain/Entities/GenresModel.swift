//
//  GenresModel.swift
//  TheMovieDB
//
//  Created by DS on 03/05/21.
//

import Foundation

struct GenresModel: Codable {
    let genres: [GenresList]?
    
    enum CodingKeys: String, CodingKey {
        case genres
    }
    
    func getlistOfName(ids: [Int]) -> String {
        var genresList = [GenresList]()
        for item in genres ?? [] {
            if ids.contains(item.id ?? 0) {
                genresList.append(item)
            }
        }
        return genresList.map({ $0.name ?? "" }).joined(separator: " • ")
    }
}

struct GenresList: Codable {
    let id: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}
