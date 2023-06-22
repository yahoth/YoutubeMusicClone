//
//  QuickSelection.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/22.
//

import Foundation

struct QuickSelection: Hashable, Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let artist: String
}

extension QuickSelection {
    static let mocks = [
        QuickSelection(imageName: "endure...", title: "차마...", artist: "성시경"),
        QuickSelection(imageName: "marigold", title: "이브, 프시케, 그리고 푸른 수염의 아내asdasdasdasasdasdasdasdasaSaSasasdasdasasdas", artist: "aimyon"),
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
