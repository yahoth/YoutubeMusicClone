//
//  HomeViewModel.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/28.
//

import UIKit
import Combine

final class HomeViewModel {
    typealias Section = HomeViewSection

    var apiManager: APIManager

    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }

    let moreButtonTapped = PassthroughSubject<Int, Never>()

    let listenAgain = CurrentValueSubject<[AudioTrack], Never>([])
    let quickPicks = CurrentValueSubject<[AudioTrack], Never>([])
    let yourMusicTuner = PassthroughSubject<YourMusicTuner, Never>()
    let mixedForYou = CurrentValueSubject<[PlaylistInfo], Never>([])
    let playlistCard = CurrentValueSubject<PlaylistCard?, Never>(PlaylistCard(id: "", title: "", imageName: "", description: "", tracks: []))

    let didSelectItem = PassthroughSubject<(section: Section, item: Any, tracks: [AudioTrack]), Never>()

    var subscriptions = Set<AnyCancellable>()

    func fetch() {
        apiManager.$accessToken.receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { token in
                self.apiManager.fetchPlaylistItem(playlistID: "37i9dQZF1DX3ZeFHRhhi7Y", tracks: self.listenAgain) // ListenAgain
                self.apiManager.fetchPlaylistItem(playlistID: "0HqwnwTY7L4IYeg5iOcMsP", tracks: self.quickPicks) // QuickPicks
                self.apiManager.fetchFeaturedPlaylists(playlist: self.mixedForYou) // MixedForYou
                self.apiManager.fetchPlaylist(playlist: self.playlistCard) // PlaylistCard
            }.store(in: &subscriptions)
    }

    func refresh() {
        apiManager.requestAccessToken()
    }
}

