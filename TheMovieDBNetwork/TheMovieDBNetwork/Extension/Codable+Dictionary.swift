//
//  Codable+Dictionary.swift
//  TheMovieDBNetwork
//
//  Created by DS on 02/05/21.
//

import Foundation

public extension Encodable {
    
    func asDictionary() -> [String: Any] {
        
        do {
            let data = try JSONEncoder().encode(self)
            guard let dictionary = try JSONSerialization.jsonObject(with: data,
                                                                    options: .allowFragments) as? [String: Any] else {
                return [:]
            }
            
            return dictionary
        } catch {
            return [:]
        }
    }
    
}
