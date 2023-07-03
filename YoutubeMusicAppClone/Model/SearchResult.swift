//
//  SearchResult.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/03.
//

import Foundation

struct SearchResult: Hashable, Decodable {
    let artists: Artists
    
    struct Artists: Hashable, Decodable {
        let items: [Items]
    }
    
    struct Items: Hashable, Decodable {
        let id: String
        let images: [SpotifyImage]
        let name: String
    }
}
