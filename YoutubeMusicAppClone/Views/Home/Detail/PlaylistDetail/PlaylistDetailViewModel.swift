//
//  PlaylistDetailViewModel.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/17.
//

import Foundation
import Combine

final class PlaylistDetailViewModel {

    var subscriptions = Set<AnyCancellable>()

    var apiManager: APIManager!

    @Published var playlistInfo: CustomMix

    let playlistTrack = CurrentValueSubject<[AudioTrack], Never>([])

    init(apiManager: APIManager, playlistInfo: CustomMix) {
        self.apiManager = apiManager
        self.playlistInfo = playlistInfo
        bind()
    }

    private func bind() {
        $playlistInfo.receive(on: RunLoop.main)
            .sink { info in
                self.apiManager.fetchPlaylistItem(playlistID: info.id, tracks: self.playlistTrack)
            }.store(in: &subscriptions)
    }
}
