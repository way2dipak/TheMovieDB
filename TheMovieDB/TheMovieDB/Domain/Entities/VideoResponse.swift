//
//  VideoResponse.swift
//  TheMovieDB
//
//  Created by DS on 16/09/21.
//

import Foundation

// MARK: - Welcome
struct VideoResponse: Codable {
    let streamingData: StreamingData?
    let videoDetails: VideoDetails?
    let playabilityStatus: PlayabilityStatus?
}

// MARK: - StreamingData
struct StreamingData: Codable {
    let expiresInSeconds: String
    let formats, adaptiveFormats: [Format]
}

// MARK: - Format
struct Format: Codable {
    let itag: Int
    let url: String
    let mimeType: String
    let bitrate: Int
    let width, height: Int?
    let initRange, indexRange: Range?
    let lastModified: String
    let contentLength: String?
    let quality: String
    let fps: Int?
    let qualityLabel: String?
    let projectionType: ProjectionType
    let averageBitrate: Int?
    let approxDurationMS: String
    let colorInfo: ColorInfo?
    let highReplication: Bool?
    let audioQuality, audioSampleRate: String?
    let audioChannels: Int?
    let loudnessDB: Double?

    enum CodingKeys: String, CodingKey {
        case itag, url, mimeType, bitrate, width, height, initRange, indexRange, lastModified, contentLength, quality, fps, qualityLabel, projectionType, averageBitrate
        case approxDurationMS = "approxDurationMs"
        case colorInfo, highReplication, audioQuality, audioSampleRate, audioChannels
        case loudnessDB = "loudnessDb"
    }
}

// MARK: - ColorInfo
struct ColorInfo: Codable {
    let primaries: Primaries
    let transferCharacteristics: TransferCharacteristics
    let matrixCoefficients: MatrixCoefficients
}

enum MatrixCoefficients: String, Codable {
    case colorMatrixCoefficientsBt709 = "COLOR_MATRIX_COEFFICIENTS_BT709"
}

enum Primaries: String, Codable {
    case colorPrimariesBt709 = "COLOR_PRIMARIES_BT709"
}

enum TransferCharacteristics: String, Codable {
    case colorTransferCharacteristicsBt709 = "COLOR_TRANSFER_CHARACTERISTICS_BT709"
}

// MARK: - Range
struct Range: Codable {
    let start, end: String
}

enum ProjectionType: String, Codable {
    case rectangular = "RECTANGULAR"
}

// MARK: - VideoDetails
struct VideoDetails: Codable {
    let videoID, title, lengthSeconds: String?
    let keywords: [String]?
    let channelID: String?
    let isOwnerViewing: Bool?
    let shortDescription: String?
    let isCrawlable: Bool?
    let thumbnail: VideoDetailsThumbnail?
    let averageRating: Double?
    let allowRatings: Bool?
    let viewCount, author: String?
    let isPrivate, isUnpluggedCorpus, isLiveContent: Bool?

    enum CodingKeys: String, CodingKey {
        case videoID = "videoId"
        case title, lengthSeconds, keywords
        case channelID = "channelId"
        case isOwnerViewing, shortDescription, isCrawlable, thumbnail, averageRating, allowRatings, viewCount, author, isPrivate, isUnpluggedCorpus, isLiveContent
    }
}

// MARK: - VideoDetailsThumbnail
struct VideoDetailsThumbnail: Codable {
    let thumbnails: [ThumbnailElement]
}

// MARK: - ThumbnailElement
struct ThumbnailElement: Codable {
    let url: String
    let width, height: Int
}

// MARK:- PlayabilityStatus
struct PlayabilityStatus: Codable {
    let status: String?
    let contextParams: String?
    let reason: String?   
}
