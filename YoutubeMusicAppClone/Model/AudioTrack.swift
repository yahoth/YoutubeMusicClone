//
//  AudioTrack.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/17.
//

import Foundation

struct AudioTrack: Hashable, Identifiable, Decodable {
    let id: String
    let imageName: String
    let title: String
    let artist: String
    let preview_url: String
}
