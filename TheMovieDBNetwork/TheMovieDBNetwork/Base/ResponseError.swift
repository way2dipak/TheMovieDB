//
//  ResponseError.swift
//  TheMovieDBNetwork
//
//  Created by DS on 02/05/21.
//

import Foundation

enum ResponseError: Error {
    case unknownError
    case noServerResponse
    case unAuthorised
    case badRequest
    case resourceNotFound
    case accessForbiden
    case noData
}

extension ResponseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknownError:
            return "Unknown Error"
        case .noServerResponse:
            return "No Server Request"
        case .unAuthorised:
            return "Unauthorised"
        case .badRequest:
            return "Bad Request"
        case .resourceNotFound:
            return "Resource Not Found"
        case .accessForbiden:
            return "Access Forbidden"
        case .noData:
            return "No Data"
        }
    }
}

