//
//  MovieDetailsVwModel.swift
//  TheMovieDB
//
//  Created by DS on 16/05/21.
//

import Foundation
import PromiseKit

class MovieDetailsVwModel {
    
    var movieDetails: MovieDetailsResponse?
    var streamDetails: VideoResponse?
    
    var movieList = [HomeModel]()
    private let service = FetchMovieServices()
    
    var refreshUI: (() -> ())?
    var playVideo: ((String) -> ())?
    var videoError: ((String) -> ())?
    
    func getMovieDetails(by id: Int, and type: MediaType = .movie) {
        firstly {
            service.fetchMovieDetails(by: id, type: type)
        }.done ({ response in
            if let result = response.result {
                self.movieDetails = result
                //self.refreshUI?()
                self.getAllDetails(by: id)
            }
        }).catch ({ error in
            print("error==========\(error.localizedDescription)")
        })
    }
    
    func getAllDetails(by movieId: Int) {
        firstly {
            when(fulfilled: service.fetchCastAndCrewList(by: movieId),
                 service.fetchTrailerAndVideoList(by: movieId),
                 service.fetchRecommendedMovieList(by: movieId),
                 service.fetchSimilarMovieList(by: movieId)
            )
        }.done ({ crew, trailers, recommended, similar in
            if let crewList = crew.result?.cast, crewList.count != 0 {
                self.movieList.append(HomeModel(sectionName: "Cast & Crew", castAndCrewContent: crewList.filter({ $0.profilePath != nil }), contentType: .castAndCrew))
            }
            if let trailersList = trailers.result?.trailersList, trailersList.count != 0 {
                self.movieList.append(HomeModel(sectionName: "Trailers", trailersContent: trailersList, contentType: .trailers))
            }
            if let recommendedList = recommended.result?.results, recommendedList.count != 0 {
                self.movieList.append(HomeModel(sectionName: "Recommended Movies", content: recommendedList, contentType: .recommended))
            }
            if let similarList = similar.result?.results, similarList.count != 0 {
                self.movieList.append(HomeModel(sectionName: "Similar Movies", content: similarList, contentType: .similar))
            }
            self.refreshUI?()
            
        }).catch ({ error in
            print("error==========\(error.localizedDescription)")
        })
    }
    
    func getVideoForHeader() -> String {
        let trailerList = movieList.filter({ $0.sectionName.lowercased() == "trailers" })
        return trailerList.first?.trailersContent.randomElement()?.key ?? ""
    }
    
    func getStreamURL(for videoID: String) {
        firstly {
            service.fetchStreamURL(with: getVideoParams(id: videoID))
        }.done ({ response in
            if let result = response.result {
                self.streamDetails = result
                if result.streamingData != nil {
                    self.playVideo?(result.streamingData?.formats.last?.url ?? "")
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
