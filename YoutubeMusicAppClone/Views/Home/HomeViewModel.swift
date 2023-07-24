//
//  HomeViewModel.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/28.
//

import UIKit
import Combine

final class HomeViewModel {
    var apiManager: APIManager

    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }

    let moreButtonTapped = PassthroughSubject<Int, Never>()

    let agains = CurrentValueSubject<[AudioTrack], Never>([])
    let quickSelections = CurrentValueSubject<[AudioTrack], Never>([])
    let myStation = PassthroughSubject<MyStation, Never>()
    let customMixes = CurrentValueSubject<[Playlist], Never>([])
    let playlistCard = PassthroughSubject<PlaylistCard, Never>()

    var subscriptions = Set<AnyCancellable>()

    func fetch() {
        apiManager.$accessToken.receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { token in
                self.apiManager.fetchPlaylistItem(playlistID: "37i9dQZF1DX3ZeFHRhhi7Y", tracks: self.agains) // ListenAgain
                self.apiManager.fetchPlaylistItem(playlistID: "0HqwnwTY7L4IYeg5iOcMsP", tracks: self.quickSelections) // QuickSelection
                self.apiManager.fetchFeaturedPlaylists(playlist: self.customMixes) // CustomMix
                self.apiManager.fetchPlaylist(playlist: self.playlistCard) // PlaylistCard
            }.store(in: &subscriptions)
    }

//    private func fetchMyStation() {
//        myStation.send(MyStation.mock)
//    }
}

