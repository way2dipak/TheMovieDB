//
//  MovieDetailsVwModel.swift
//  TheMovieDB
//
//  Created by DS on 16/05/21.
//

import Foundation
import PromiseKit

class MovieDetailsVwModel {
    
    var movieDetails: MovieResultList?
    var streamDetails: VideoResponse?
    
    var movieList = [HomeList]()
    private let service = FetchMovieServices()
    
    var refreshUI: (() -> ())?
    var playVideo: ((String) -> ())?
    var videoError: ((String) -> ())?
    
    func getMovieDetails(by id: Int, and type: MediaType = .movie) {
        firstly {
            service.fetchMovieDetails(by: id)
        }.done ({ results in
            if let details = results.result, details.success ?? false {
                self.movieList = details.results ?? []
                self.movieDetails = details.results?.filter({$0.sectionTitle?.lowercased() ?? "" == "header"}).first?.sectionData?.first
                self.refreshUI?()
            }
        }).catch ({ error in
            print("error==========\(error.localizedDescription)")
        })
    }
    
    func getVideoForHeader() -> String {
        let trailerList = movieList.filter({ $0.sectionTitle?.lowercased() == "trailers" })
        return trailerList.first?.sectionData?.randomElement()?.key ?? ""
    }
    
    func getVideoListAt(index: IndexPath) -> [MovieResultList] {
        return movieList[index.row].sectionData ?? []
    }
    
    func getStreamURL(for videoID: String) {
        firstly {
            service.fetchStreamURL(with: getVideoParams(id: videoID))
        }.done ({ response in
            if let result = response.result {
                self.streamDetails = result
                if result.streamingData != nil {
                    self.playVideo?(result.streamingData?.formats.first?.url ?? "")
                } else {
                    self.videoError?(result.playabilityStatus?.reason ?? "")
                }
            }
        }).catch ({ [weak self] error in
            guard let self = self else { return }
            self.videoError?("Video unavailable")
            print("error==========\(error.localizedDescription)")
        })
    }
    
    private func getVideoParams(id: String) -> [String: Any] {
        return [
                "context": [
                    "client": [
                        "hl": "en",
                        "clientName": "WEB",
                        "clientVersion": "2.20210721.00.00",
                        "clientFormFactor": "UNKNOWN_FORM_FACTOR",
                        "clientScreen": "WATCH",
                        "mainAppWebInfo": [
                            "graftUrl": "/watch?v=\(id)"
                        ]
                    ],
                    "user": [
                        "lockedSafetyMode": false
                    ],
                    "request": [
                        "useSsl": true,
                        "internalExperimentFlags": [],
                        "consistencyTokenJars": []
                    ]
                ],
                "videoId": "\(id)",
                "playbackContext": [
                    "contentPlaybackContext": [
                        "vis": 0,
                        "splay": false,
                        "autoCaptionsDefaultOn": false,
                        "autonavState": "STATE_NONE",
                        "html5Preference": "HTML5_PREF_WANTS",
                        "lactMilliseconds": "-1"
                    ]
                ],
                "racyCheckOk": false,
                "contentCheckOk": false
            ]
    }
    
//    deinit {
//        movieDetails = nil
//        print("------MovieDetailsViewModel deinited-----")
//    }
    
}
