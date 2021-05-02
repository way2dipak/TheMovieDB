//
//  DataProcessor.swift
//  TheMovieDBNetwork
//
//  Created by DS on 02/05/21.
//

import Foundation

struct DataProcessor<Element: Codable> {
    
    // serialize
    static func serialize ( data: Element ) -> [String: Any] {
        return data.asDictionary()
    }
    
    
    // deserialize
    static func deserialize (_ data: Data,
                             onCompilation: @escaping (_ data: Element?, _ error: Error?) -> Void) {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(Element.self, from: data)
           // print("Response decoded data:: \(decodedData)\n========\n\n")
            
            onCompilation(decodedData, nil)
        } catch {
            print("Error while decoding response:: \(error)")
           // assertionFailure()
            
            onCompilation(nil, error)
        }
    }
}
