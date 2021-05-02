//
//  BaseRequest.swift
//  TheMovieDBNetwork
//
//  Created by DS on 02/05/21.
//

import Foundation
import Alamofire

public protocol BaseRequest {
    var route: (method: HTTPMethod, path: String) { get }
}
