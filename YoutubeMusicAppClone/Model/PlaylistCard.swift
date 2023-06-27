//
//  PlaylistCard.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/27.
//

import Foundation

struct RecommendList: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let recommender: String
    let description: String
    let list: [PlaylistCard]
}

extension RecommendList {
    static let mock = RecommendList(title: "매력 어필 힙합/R&B", imageName: "marigold", recommender: "YouTube Music", description: "치명적인 매력으로 도발하는 힙합/R&B 음악을 감상해보세요.", list: PlaylistCard.mocks)
}

struct PlaylistCard: Hashable, Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let artist: String
    let releaseDate: String
    
    var subTitle: String {
        "\(artist) • \(releaseDate)"
    }
}

extension PlaylistCard {
    static let mocks = [
        PlaylistCard(imageName: "marigold", title: "marigold", artist: "aimyon", releaseDate: "2020"),
        PlaylistCard(imageName: "endure...", title: "Sunflower (Spider-Man:Into the Spider-Verse)", artist: "Post Malone, Swae Lee", releaseDate: "2019"),
        PlaylistCard(imageName: "marigold", title: "이브, 프시케, 그리고 푸른 수염의 아내", artist: "aimyon", releaseDate: "2023"),
        PlaylistCard(imageName: "marigold", title: "marigold", artist: "aimyon", releaseDate: "2020"),
        PlaylistCard(imageName: "endure...", title: "Sunflower (Spider-Man:Into the Spider-Verse)", artist: "Post Malone, Swae Lee", releaseDate: "2019"),
        PlaylistCard(imageName: "marigold", title: "이브, 프시케, 그리고 푸른 수염의 아내", artist: "aimyon", releaseDate: "2023"),
        PlaylistCard(imageName: "marigold", title: "marigold", artist: "aimyon", releaseDate: "2020"),
        PlaylistCard(imageName: "endure...", title: "Sunflower (Spider-Man:Into the Spider-Verse)", artist: "Post Malone, Swae Lee", releaseDate: "2019"),
        PlaylistCard(imageName: "marigold", title: "이브, 프시케, 그리고 푸른 수염의 아내", artist: "aimyon", releaseDate: "2023"),
    ]
}
