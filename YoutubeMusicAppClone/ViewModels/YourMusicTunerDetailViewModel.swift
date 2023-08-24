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

    @Published var artists: [RelatedArtistsResponse.Artists] = []

    var subscription = Set<AnyCancellable>()

    func fetch() {
        apiManager.fetchArtists()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Fetch artists error: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { artists in
                self.artists = artists
            }.store(in: &subscription)
    }

    deinit {
        print("YourMusicTuner VM deinit")
    }

}
