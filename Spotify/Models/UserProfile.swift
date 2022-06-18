//
//  UserProfile.swift
//  Spotify
//
//  Created by MAC on 14/06/2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userProfile = try UserProfile(json)

import Foundation

// MARK: - UserProfile
struct UserProfile: Codable {
    let displayName: String
    let followers: Followers
    let href: String
    let id: String
    let images: [Image]
    let type, uri: String
    let externalUrls: ExternalUrls
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case followers
        case href
        case id
        case images
        case type
        case uri
        case externalUrls = "external_urls"
    }
}

// MARK: UserProfile convenience initializers and mutators

extension UserProfile {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UserProfile.self, from: data)
    }
}

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    let spotify: String?
}

// MARK: ExternalUrls convenience initializers and mutators

extension ExternalUrls {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ExternalUrls.self, from: data)
    }
    
}

// MARK: - Followers
struct Followers: Codable {
    let href: String?
    let total: Int?
}

// MARK: Followers convenience initializers and mutators

extension Followers {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Followers.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        href: String?? = nil,
        total: Int?? = nil
    ) -> Followers {
        return Followers(
            href: href ?? self.href,
            total: total ?? self.total
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Image
struct Image: Codable {
    let url: String?
}
