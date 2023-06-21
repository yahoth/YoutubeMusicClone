//
//  Music.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/21.
//

import Foundation

struct ListenAgain: Hashable, Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let artist: String
}

extension ListenAgain {
    static let mocks = [
        ListenAgain(imageName: "marigold", title: "marigold", artist: "aimyon"),
        ListenAgain(imageName: "endure...", title: "차마...", artist: "성시경"),
        ListenAgain(imageName: "marigold", title: "이브, 프시케, 그리고 푸른 수염의 아내", artist: "aimyon"),
        ListenAgain(imageName: "endure...", title: "차마...", artist: "성시경"),
        ListenAgain(imageName: "marigold", title: "marigold", artist: "aimyon"),
        ListenAgain(imageName: "endure...", title: "차마...", artist: "성시경"),
        ListenAgain(imageName: "marigold", title: "marigold", artist: "aimyon"),
        ListenAgain(imageName: "endure...", title: "차마...", artist: "성시경"),
        ListenAgain(imageName: "marigold", title: "marigold", artist: "aimyon"),
        ListenAgain(imageName: "endure...", title: "차마...", artist: "성시경"),
        ListenAgain(imageName: "marigold", title: "marigold", artist: "aimyon"),
        ListenAgain(imageName: "endure...", title: "차마...", artist: "성시경"),
        ListenAgain(imageName: "marigold", title: "marigold", artist: "aimyon"),
        ListenAgain(imageName: "endure...", title: "차마...", artist: "성시경"),
        ListenAgain(imageName: "marigold", title: "marigold", artist: "aimyon"),
        ListenAgain(imageName: "endure...", title: "차마...", artist: "성시경"),
    ]
}

struct QuickSelection: Hashable, Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let artist: String
}

extension QuickSelection {
    static let mocks = [
        QuickSelection(imageName: "endure...", title: "차마...", artist: "성시경"),
        QuickSelection(imageName: "marigold", title: "이브, 프시케, 그리고 푸른 수염의 아내", artist: "aimyon"),
        QuickSelection(imageName: "endure...", title: "차마...", artist: "성시경"),
        QuickSelection(imageName: "marigold", title: "marigold", artist: "aimyon"),
        QuickSelection(imageName: "endure...", title: "차마...", artist: "성시경"),
        QuickSelection(imageName: "marigold", title: "marigold", artist: "aimyon"),
        QuickSelection(imageName: "endure...", title: "차마...", artist: "성시경"),
        QuickSelection(imageName: "marigold", title: "marigold", artist: "aimyon"),
        QuickSelection(imageName: "endure...", title: "차마...", artist: "성시경"),
        QuickSelection(imageName: "marigold", title: "marigold", artist: "aimyon"),
        QuickSelection(imageName: "endure...", title: "차마...", artist: "성시경"),
        QuickSelection(imageName: "marigold", title: "marigold", artist: "aimyon"),
        QuickSelection(imageName: "endure...", title: "차마...", artist: "성시경"),
        QuickSelection(imageName: "marigold", title: "marigold", artist: "aimyon"),
        QuickSelection(imageName: "endure...", title: "차마...", artist: "성시경"),
        QuickSelection(imageName: "marigold", title: "marigold", artist: "aimyon"),
    ]

}
