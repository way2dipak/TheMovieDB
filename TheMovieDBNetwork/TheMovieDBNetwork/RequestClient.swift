//
//  RequestClient.swift
//  TheMovieDBNetwork
//
//  Created by DS on 02/05/21.
//

import Alamofire
import PromiseKit

open class RequestClient {
    
    func request<T: Codable>(_ url: URL,
                             method: HTTPMethod,
                             parameters: [String: Any]?,
                             headers: HTTPHeaders) -> Promise<T> {
        
        return AF.request(url,
                          method: method,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .cURLDescription(calling: { (requestDescription) in
                debugResponse(requestDescription: requestDescription)
            })
            .responseCodable()
    }
}

