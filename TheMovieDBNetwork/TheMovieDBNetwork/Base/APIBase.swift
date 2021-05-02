//
//  ApiBase.swift
//  TheMovieDBNetwork
//
//  Created by DS on 02/05/21.
//

public struct APIBase {
    public static var currentEnv = Env.dev
}

public enum Env {
    case dev
    
    public var url: String {
        switch self {
        case .dev:
            return  "https://api.themoviedb.org/3/"
        }
    }
    
    public var imgUrl: String {
        switch self {
        case .dev:
            return "http://image.tmdb.org/t/p/w780/"
        }
    }
    
}

