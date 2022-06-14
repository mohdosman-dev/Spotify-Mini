//
//  SettingsModel.swift
//  Spotify
//
//  Created by MAC on 14/06/2022.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
