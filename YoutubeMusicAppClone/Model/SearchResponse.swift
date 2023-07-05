//
//  SearchResult.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/03.
//

import Foundation

struct SearchResponse: Hashable, Decodable {
    let artists: ArtistsResponse?
    let tracks: Tracks?
    
    struct ArtistsResponse: Hashable, Decodable {
        let items: [Items]
    }
    
    struct Items: Hashable, Decodable {
        let id: String
        let images: [SpotifyImage]
        let name: String
    }
    
    struct Tracks: Hashable, Decodable {
        let items: [TracksItems]
    }
    struct TracksItems: Hashable, Decodable, Identifiable {
        let id: String
        let album: Album
        let name: String
        let duration: Int
        
        enum CodingKeys: String, CodingKey {
            case id
            case album
            case name
            case duration = "duration_ms"
        }
    }
    struct Album: Hashable, Decodable {
        let images: [SpotifyImage]
        let artists: [Artists]
    }
    
    struct Artists: Hashable, Decodable {
        let name: String
    }
    
}
