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
    case local
    case dev
    case prod
    
    public var url: String {
        switch self {
        case .local:
            return "http://localhost:8000/v1/"
        case .dev:
            return "http://moviedbnodejs.herokuapp.com/v1/"
        case .prod:
            return "http://35.173.249.132:8000/v1/"
        }
    }
    
    public var imgUrl: String {
        switch self {
        case .local, .dev, .prod:
            return "http://image.tmdb.org/t/p/"
        }
    }
    
    public var videoUrl: String {
        switch self {
        case .local, .dev, .prod:
            return "https://www.youtube.com/"
        }
    }
    
    public var token: String {
        switch self {
        case .local, .dev, .prod:
            return APIKEY
        }
    }
    
}

