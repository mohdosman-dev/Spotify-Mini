//
//  PlaylistDetailsResponse.swift
//  Spotify
//
//  Created by MAC on 18/06/2022.
//

import Foundation

struct PlaylistDetailsResponse: Codable {
    let description: String
    let externalUrl: [String:String]
    let id: String
    let images: [Image]
    let name: String
    let owner: Owner
    let tracks: PlaylistTrackResponse
    
    
    enum CodingKeys: String, CodingKey {
        case description
        case externalUrl = "external_urls"
        case id
        case images
        case name
        case owner
        case tracks = "tracks"
    }
}

struct PlaylistTrackResponse: Codable {
    let items: [PlaylistItemResponse]
}

struct PlaylistItemResponse: Codable {
    let track: AudioTrack
}
