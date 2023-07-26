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

    var FormattedDurationTime: String {
        //제공받는 타입은 Int, 예시: 184444 -> 3:05
        //4번째수에서 올림하여 185로 만든 뒤 3:05로 변환
        let digit: Double = pow(10, 3)
        let durationTime = Int(ceil(Double(duration) / digit))
        let minutes = durationTime / 60
        let seconds = durationTime % 60

        return String(format: "%2d:%02d", minutes, seconds)
    }

}
