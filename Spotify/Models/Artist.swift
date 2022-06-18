//
//  Artist.swift
//  Spotify
//
//  Created by MAC on 14/06/2022.
//

import Foundation


// MARK: - Artist
struct Artist: Codable {
    let externalUrls: ExternalUrls
    let href: String
    let id, name, type, uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href
        case id
        case name
        case type
        case uri
    }
}
