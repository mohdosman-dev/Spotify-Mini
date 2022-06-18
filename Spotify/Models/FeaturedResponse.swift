//
//  FeaturedResponse.swift
//  Spotify
//
//  Created by MAC on 15/06/2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let featuredResponse = try? newJSONDecoder().decode(FeaturedResponse.self, from: jsonData)

import Foundation

// MARK: - FeaturedResponse
struct FeaturedResponse: Codable {
    let playlists: PlaylistResponse
}

// MARK: - Playlists
struct PlaylistResponse: Codable {
    let href: String
    let items: [Playlist]
    let total: Int
}

// MARK: - Owner
struct Owner: Codable {
    let displayName: String
    let externalUrls: ExternalUrls
    let href: String
    let id, type, uri: String
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case externalUrls = "external_urls"
        case href, id, type, uri
    }
}

// MARK: - Tracks
struct Tracks: Codable {
    let href: String
    let total: Int
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
