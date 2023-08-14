//
//  PlaylistCard.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/27.
//

import Foundation

struct PlaylistCard: Hashable, Identifiable, Decodable {
    let id: String
    let title: String
    let imageName: String
    let description: String
    let tracks: [AudioTrack]
}
