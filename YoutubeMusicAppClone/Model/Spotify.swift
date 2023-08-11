//
//  Artist.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/28.
//

import Foundation

struct SpotifyImage: Decodable, Hashable {
    var height: Int?
    var width: Int?
    var url: String
}


//get featured-playlists
//click시 id를 통해 api호출하여 리스트를 뽑는다.
struct FeaturedPlaylistResponse: Hashable, Decodable{
    let playlists: Item

    struct Item: Hashable, Decodable {
        let items: [PlaylistInfo]
    }

    struct PlaylistInfo: Hashable, Decodable {
        let id: String
        let description: String
        let images: [SpotifyImage]
        let name: String
    }
}

// get playlist items
struct PlaylistItemsResponse: Hashable, Decodable {
    let items: [Items]

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
    }

    struct Album: Hashable, Decodable {
        let artists: [Artists]
        let releaseDate: String
        let images: [SpotifyImage]
        let previewURL: String?
        let duration: Int

        enum CodingKeys: String, CodingKey {
            case artists
            case releaseDate = "release_date"
            case images
            case previewURL = "preview_url"
            case duration = "duration_ms"
        }
    }

    struct Artists: Hashable, Decodable {
        let name: String
    }

}

