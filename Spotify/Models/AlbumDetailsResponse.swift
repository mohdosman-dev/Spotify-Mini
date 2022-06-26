//
//  AlbumDetailsResponse.swift
//  Spotify
//
//  Created by MAC on 18/06/2022.
//

import Foundation

struct AlbumDetailsResponse: Codable {
    let albumType: String
    let artists: [Artist]
    let images: [Image]
    let availableMarkets: [String]
    let externalUrls: [String:String]
    let id:String
    let label:String
    let name:String
    let tracks: TrackResponse
    
    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case images
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case id
        case label
        case name
        case tracks = "tracks"
    }
}

struct TrackResponse: Codable {
    let items: [AudioTrack]
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
}
