//
//  Playlist.swift
//  Spotify
//
//  Created by MAC on 14/06/2022.
//

import Foundation


// MARK: - Playlist
struct Playlist: Codable {
    let collaborative: Bool
    let itemDescription: String
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let images: [Image]
    let name: String
    let owner: Owner
    let primaryColor:JSONNull?
    let itemPublic: JSONNull?
    let snapshotID: String
    let tracks: Tracks
    let type, uri: String
    
    enum CodingKeys: String, CodingKey {
        case collaborative
        case itemDescription = "description"
        case externalUrls = "external_urls"
        case href
        case id
        case images
        case name
        case owner
        case primaryColor = "primary_color"
        case itemPublic = "public"
        case snapshotID = "snapshot_id"
        case tracks
        case type
        case uri
    }
}
