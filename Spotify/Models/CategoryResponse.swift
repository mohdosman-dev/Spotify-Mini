//
//  CategoryResponse.swift
//  Spotify
//
//  Created by MAC on 26/06/2022.
//

import Foundation

struct CategoryResponse: Codable {
    let categories: Category
}

struct Category: Codable {
    let items: [CategoryItem]
}

struct CategoryItem: Codable {
    let id: String
    let name: String
    let icons: [Image]
}
