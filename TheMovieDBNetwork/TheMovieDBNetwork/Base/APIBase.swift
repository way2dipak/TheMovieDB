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
    case prod
    
    public var url: String {
        switch self {
        case .dev:
            return  "https://api.themoviedb.org/3/"
        case .prod:
            return "http://35.173.249.132:8000"
        }
    }
    
    public var imgUrl: String {
        switch self {
        case .dev, .prod:
            return "http://image.tmdb.org/t/p/"
        }
    }
    
    public var videoUrl: String {
        switch self {
        case .dev, .prod:
            return "https://www.youtube.com/"
        }
    }
    
}

