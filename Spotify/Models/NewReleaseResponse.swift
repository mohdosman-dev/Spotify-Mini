//
//  NewReleaseResponse.swift
//  Spotify
//
//  Created by MAC on 15/06/2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newReleaseResponse = try? newJSONDecoder().decode(NewReleaseResponse.self, from: jsonData)

import Foundation

// MARK: - NewReleaseResponse
struct NewReleaseResponse: Codable {
    let albums: Albums
}

// MARK: - Albums
struct Albums: Codable {
    let items: [Album]
    let total: Int
}

// MARK: - Item
struct Album: Codable {
    let albumType: String
    let artists: [Artist]
    let availableMarkets: [String]
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let images: [AlbumImage]
    let name: String
    let releaseDate, type, releaseDatePrecision: String
    let totalTracks: Int
    let uri: String

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href
        case id
        case images = "images"
        case name
        case releaseDate = "release_date"
        case type
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case uri
    }
}


// MARK: - Image
struct AlbumImage: Codable {
    let url: String
}
