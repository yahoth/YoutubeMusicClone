//
//  CustomMix.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/27.
//

import Foundation

struct Playlist: Hashable {
    let id: String
    let uuid = UUID().uuidString
    let description: String
    let images: [SpotifyImage]
    let name: String
}
