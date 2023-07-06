//
//  RelatedArtistsResponse.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/06.
//

import Foundation

struct RelatedArtistsResponse: Decodable, Hashable {
    let artists: [Artists]
    
    struct Artists: Decodable, Hashable {
        let images: [SpotifyImage]
        let name: String
    }
}
