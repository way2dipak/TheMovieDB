//
//  BaseService.swift
//  TheMovieDBNetwork
//
//  Created by DS on 02/05/21.
//

import PromiseKit
import Alamofire
import TheMovieDBPersistence

open class BaseService: RequestClient {
    
    let baseURL: String
    
    public init(baseURL: String = APIBase.currentEnv.url) {
        self.baseURL = baseURL
    }
    
    func attempt<Element>(maximumRetryCount: Int = 2,
                          delayBeforeRetry: DispatchTimeInterval = .seconds(2),
                          _ body: @escaping () -> Promise<Element>) -> Promise<Element> {
        
        var attempts = 0
        func attempt() -> Promise<Element> {
            attempts += 1
            return body().recover { error -> Promise<Element> in
                if let mappedError = error as? ResponseError {
                    
                    guard !(mappedError == ResponseError.accessForbiden ||
                                mappedError == ResponseError.badRequest || mappedError == ResponseError.resourceNotFound) else {
                        
                        throw error
                    }
                }
                
                guard attempts < maximumRetryCount else { throw error }
                return after(delayBeforeRetry).then(on: nil, attempt)
            }
        }
        return attempt()
    }
    
    public func data<Element: Codable>( _ baseResource: BaseRequest,
                                        parameters: [String: Any]? = nil,
                                        headers: HTTPHeaders = ["Content-Type": "application/json"])-> Promise<ResponseModel<Element>> {
        // url
        let mappedURL = self.buildURL(baseResource.route.path)
        let encodedURL = self.encodeURL(url: mappedURL)
        
        var mutableHeaders = headers
        self.buildAuthHeader(path: mappedURL).forEach { mutableHeaders.add($0) }
        
        
        return attempt { () -> Promise<ResponseModel<Element>> in
            return self.execute(action: {
                super.request(encodedURL,
                              method: baseResource.route.method,
                              parameters: parameters,
                              headers: mutableHeaders)
            })
        }
    }
}

// MARK: - Helpers
extension BaseService {
    
    private func execute<Element>(action:() -> Promise<Element>) -> Promise<ResponseModel<Element>> {
        return Promise { seal in
            firstly {
                action()
            }.done({ result in
                seal.fulfill(ResponseModel<Element>(result: result, error: nil))
            }).catch({ error in
                seal.reject(error)
            })
        }
    }
    
    private func buildAuthHeader(path:String) -> HTTPHeaders {
        
        var header = HTTPHeaders()
        header.add(name: "Content-Type", value: "application/json")
        return header
        
    }
    
    private func buildURL( _ from: String ) -> String {
        return self.baseURL + from
    }
    
    private func encodeURL(url: String) -> URL {
        return try! url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!.asURL()
    }
    
}

