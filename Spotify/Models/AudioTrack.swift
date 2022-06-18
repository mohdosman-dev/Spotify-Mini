//
//  AudioTrack.swift
//  Spotify
//
//  Created by MAC on 14/06/2022.
//

import Foundation

// MARK: - AudioTrack
struct AudioTrack: Codable {
    let album: Album
    let artists: [Artist]
    let availableMarkets: [String]
    let discNumber: Int
    let durationMs: Int
    let explicit: Bool
    let href: String
    let id: String
    let popularity: Int
    let trackNumber: Int
    let type: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case album
        case artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case explicit
        case href
        case id
        case popularity
        case trackNumber = "track_number"
        case type
        case name
    }
}
