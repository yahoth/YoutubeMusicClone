//
//  ListenAgain.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/21.
//

import Foundation

struct ListenAgain: Hashable, Identifiable, Decodable {
    let id: String
    let imageName: String
    let title: String
    let artist: String
    let preview_url: String
}
