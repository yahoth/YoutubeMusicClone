//
//  CustomMix.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/27.
//

import Foundation

struct CustomMix: Hashable, Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let artists: String
}

extension CustomMix {
    static let mocks = [
        CustomMix(imageName: "marigold", title: "한국 댄스음악 뮤직 스테이션 운동할 때 듣는", artists: "IZ*ONE(아이즈원), 스테이씨, 에스파 및 아이브"),
        CustomMix(imageName: "marigold", title: "back number 뮤직 스테이션 2010초", artists: "back number, 세카이노 오와리, Suda Masaki 및 aimyon"),
        CustomMix(imageName: "marigold", title: "marigold", artists: "hi"),
        CustomMix(imageName: "marigold", title: "marigold", artists: "hi"),
        CustomMix(imageName: "marigold", title: "marigold", artists: "hi"),
        CustomMix(imageName: "marigold", title: "marigold", artists: "hi"),
        CustomMix(imageName: "marigold", title: "marigold", artists: "hi"),
        CustomMix(imageName: "marigold", title: "marigold", artists: "hi"),
        
    ]
}
