//
//  PlaylistItemsResponse.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/08/12.
//

import Foundation

// get playlist items
struct PlaylistItemsResponse: Hashable, Decodable {
    let items: [Items]

    struct Items: Hashable, Decodable {
        let track: Track?
    }

    struct Track: Hashable, Decodable {
        let album: Album
        let name: String
        let id: String
        let previewURL: String?
        let duration: Int

        enum CodingKeys: String, CodingKey {
            case id
            case album
            case name
            case duration = "duration_ms"
            case previewURL = "preview_url"
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
