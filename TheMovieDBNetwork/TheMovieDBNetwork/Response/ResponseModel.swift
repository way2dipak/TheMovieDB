//
//  ResponseModel.swift
//  TheMovieDBNetwork
//
//  Created by DS on 02/05/21.
//

import Foundation

public struct ResponseModel<Element> {
    public var result: Element?
    public var error: ResponseErrorModel<Element>?
}

public struct ErrorMessages: Codable {
    let message: [String]
}

public struct ResponseErrorModel<Element> {
    let statusCode: Int
    let message: String
    let properties: Element?
}
