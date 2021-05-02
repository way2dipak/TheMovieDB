//
//  Alamofire+Response+Process.swift
//  TheMovieDBNetwork
//
//  Created by DS on 02/05/21.
//

import PromiseKit
import Alamofire
import TheMovieDBPersistence

extension Alamofire.DataRequest {
    // Return a Promise for a Codable
    public func responseCodable<T: Codable>() -> Promise<T> {
        let successCode = [200, 202, 201, 203]
        return Promise<T> { seal in
            responseData() { serverResponse in
                guard let gaurdedResponse = serverResponse.response else {
                    seal.reject(ResponseError.noServerResponse);
                    return
                }
                
                guard let value = serverResponse.data else {
                    seal.reject(ResponseError.unknownError)
                    return
                }
                
                // OPTIONAL - DEBUG RESPONSE
                #if DEBUG
                print("\n\nResponse DATA::: \(value.toPrettyJSONString ?? "")\n\n")
                
                print("\n\nResponse Headers:::\(String(describing: serverResponse.response?.allHeaderFields.description))\n\n")
                #endif

                switch gaurdedResponse.statusCode {
                // Success
                case 200..<300:
                    // process data
                    DataProcessor<T>.deserialize(value) { (decodedResponse, error) in
                        if error != nil {
                            // assertionFailure()
                            seal.reject(error!)
                        } else {
                            seal.fulfill(decodedResponse!)
                        }
                    }
                case 400:
                    DataProcessor<T>.deserialize(value) { (decodedResponse, error) in
                        if error != nil {
                            // assertionFailure()
                            seal.reject(error!)
                        } else {
                            seal.fulfill(decodedResponse!)
                        }
                    }
                case 403:
                    seal.reject(ResponseError.accessForbiden)
                    
                case 404:
                    seal.reject(ResponseError.resourceNotFound)
                    
                case 400..<500:
                    seal.reject(ResponseError.badRequest)
                    
                case 500..<600:
                    seal.reject(ResponseError.noServerResponse)
                    
                default:
                    seal.reject(ResponseError.unknownError)
                }
                
            }
        }
    }
    
    public func getErrorMessageForResponse(data: Data) -> String {
        if let object = data.toRawJson as? [String: Any] {
            return object["message"] as? String ?? ""
        }
        return ""
    }
}

extension Data {
    var toPrettyJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString
    }
    
    var toRawJson: Any? {
        guard let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) else { return nil }
        return json
    }
}

