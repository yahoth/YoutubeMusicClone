//
//  PlaylistResponse.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/08/12.
//

import Foundation

struct PlaylistResponse: Hashable, Decodable {
    let id: String
    let description: String
    let images: [SpotifyImage]
    let name: String
    let tracks: Tracks

    struct Tracks: Hashable, Decodable {
        let items: [Items]
    }

    struct Items: Hashable, Decodable {
        let track: Track
    }

    struct Track: Hashable, Decodable {
        let album: Album
        let name: String
        let id: String
        let previewURL: String?
        let duration: Int

        enum CodingKeys: String, CodingKey {
            case album
            case name
            case id
            case previewURL = "preview_url"
            case duration = "duration_ms"
        }
    }

    struct Album: Hashable, Decodable {
        let artists: [Artists]
        let releaseDate: String
        let images: [SpotifyImage]

        enum CodingKeys: String, CodingKey {
            case artists
            case releaseDate = "release_date"
            case images
        }
    }

    struct Artists: Hashable, Decodable {
        let name: String
    }
}
