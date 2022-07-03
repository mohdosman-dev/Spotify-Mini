//
//  CategoryResponse.swift
//  Spotify
//
//  Created by MAC on 26/06/2022.
//

import Foundation

struct CategoryResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let id: String
    let name: String
    let icons: [Image]
}
