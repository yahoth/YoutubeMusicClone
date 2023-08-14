//
//  YourMusicTuner.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/22.
//

import Foundation

struct YourMusicTuner: Hashable, Identifiable {
    let id = UUID()
    let yourMusicTuner: String
}

extension YourMusicTuner {
    static let mock = YourMusicTuner(yourMusicTuner: "YourMusicTuner")
}
