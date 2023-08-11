//
//  PlaylistCard.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/27.
//

import Foundation

struct PlaylistCard: Hashable, Identifiable, Decodable {
    let id: String
    let title: String
    let imageName: String
    let description: String
    let tracks: [AudioTrack]
}

//struct Track: Hashable, Identifiable, Decodable {
//    let id: String
//    let imageName: String
//    let title: String
//    let artist: String
//    let releaseDate: String
//
//    var subTitle: String {
//        "\(artist) • \(dateFormatter(strDate: releaseDate))"
//    }
//
//    func dateFormatter(strDate: String) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let convertedDate = formatter.date(from: strDate)
//        let myFormatter = DateFormatter()
//        myFormatter.dateFormat = "yyyy"
//        let date = myFormatter.string(from: convertedDate ?? Date())
//
//        return date
//    }
//}

