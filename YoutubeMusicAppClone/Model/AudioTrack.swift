//
//  AudioTrack.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/17.
//

import Foundation

struct AudioTrack: Hashable {
    let id: String
    let uuid = UUID().uuidString
    let imageName: String
    let title: String
    let artist: String
    let previewURL: String?
    let duration: Int
}
