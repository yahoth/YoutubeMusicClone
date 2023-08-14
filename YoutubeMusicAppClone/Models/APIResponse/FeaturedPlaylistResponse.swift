//
//  FeaturedPlaylistResponse.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/08/12.
//

import Foundation

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
