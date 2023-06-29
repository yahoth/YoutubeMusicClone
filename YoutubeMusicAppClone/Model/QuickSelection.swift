//
//  QuickSelection.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/22.
//

import Foundation

struct QuickSelection: Hashable, Identifiable, Decodable {
    let id: String
    let imageName: String
    let title: String
    let artist: String
}
