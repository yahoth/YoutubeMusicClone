//
//  YourMusicTunerDetailViewModel.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/06.
//

import Foundation
import Combine

final class YourMusicTunerDetailViewModel {
    let apiManager: APIManager = APIManager.shared

    let artists = PassthroughSubject<[RelatedArtistsResponse.Artists], Never>()

    func fetch() {
        apiManager.fetchArtists(artists: artists)
    }
}
