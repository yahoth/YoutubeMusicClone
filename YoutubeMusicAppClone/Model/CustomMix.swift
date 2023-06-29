//
//  CustomMix.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/27.
//

import Foundation

struct CustomMix: Hashable, Identifiable {
    let id: String
    let description: String
    let images: [SpotifyImage]
    let name: String
}
