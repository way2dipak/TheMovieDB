//
//  Alamofire+Request+debug.swift
//  TheMovieDBNetwork
//
//  Created by DS on 02/05/21.
//

import Alamofire

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        print(self)
        
        #endif
        return self
    }
}

public func debugResponse(requestDescription: String) {
    #if DEBUG
    print(requestDescription)
    #endif
}

