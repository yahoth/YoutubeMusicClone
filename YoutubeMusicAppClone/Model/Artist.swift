//
//  Artist.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/28.
//

import Foundation

struct Artist: Decodable {
    let name: String
    let images: [SpotifyImage]
}

struct SpotifyImage: Decodable, Hashable {
    var height: Int?
    var width: Int?
    var url: String
}

struct PlayLists: Decodable{
    let playlists: Items
}

struct Items: Decodable {
    let items: [PlayList]
}

struct PlayList: Hashable, Decodable {
    let id: String
    let description: String
    let images: [SpotifyImage]
    let name: String
}

struct ListenAgain: Hashable, Identifiable, Decodable {
    let id: String
    let imageName: String
    let title: String
    let artist: String
}

struct First: Hashable, Decodable {
    let items: [Second]
}

struct Second: Hashable, Decodable {
    let track: Third
}
struct Third: Hashable, Decodable {
    let album: Album
    let name: String
    let id: String
}
struct Album: Hashable, Decodable {
    let images: [SpotifyImage]
    let artists: [Artists]
}

struct Artists: Hashable, Decodable {
    let name: String
}
