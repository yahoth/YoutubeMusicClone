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

    let apiManager: APIManager = APIManager.shared

    @Published var playlistInfo: PlaylistInfo

    let playlistTrack = CurrentValueSubject<[AudioTrack], Never>([])

    let musicStarted = PassthroughSubject<AudioTrack, Never>()

    @Published var tracks: [AudioTrack]?

    init(playlistInfo: PlaylistInfo, tracks: [AudioTrack]? = nil) {
        self.playlistInfo = playlistInfo
        self.tracks = tracks
        bind()
    }

    deinit {
        print("PlaylistDetail VM deinit")
    }

    private func bind() {
        if tracks != nil {
            $tracks
                .compactMap { $0 }
                .receive(on: RunLoop.main)
                .sink { [unowned self] tracks in
                    self.playlistTrack.send(tracks)
                }.store(in: &subscriptions)
        } else {
            $playlistInfo
                .receive(on: RunLoop.main)
                .sink { [unowned self] info in
                    self.apiManager.fetchPlaylistItem(playlistID: info.id, tracks: self.playlistTrack)
                }.store(in: &subscriptions)
        }
    }
}
