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
struct FeaturedPlaylistResponse: Decodable{
    let playlists: Item

    struct Item: Decodable {
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
        let preview_url: String?
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

