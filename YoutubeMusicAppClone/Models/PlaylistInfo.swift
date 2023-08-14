//
//  PlaylistInfo.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/27.
//

import Foundation

struct PlaylistInfo: Hashable {
    let id: String
    let uuid = UUID().uuidString
    let description: String
    let imageName: String
    let title: String
}
