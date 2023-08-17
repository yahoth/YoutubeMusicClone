//
//  MusicPlayerViewModel.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/10.
//

import UIKit
import AVFoundation
import Combine

final class MusicPlayerViewModel {

    static let shared = MusicPlayerViewModel()

    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var timeObserverToken: AnyObject?

    let item = CurrentValueSubject<AudioTrack?, Never>(nil)
    var subscriptions = Set<AnyCancellable>()
    private var endOfSongSubscription: AnyCancellable?

    var currentPlayingTracks = CurrentValueSubject<[AudioTrack]?, Never>([])

    @Published private(set) var isPlaying = false
    
    private init() {
        bind()
    }

    private func bind() {
        //fetch player
        item.receive(on: RunLoop.main)
            .sink { item in
                guard let previewStr = item?.previewURL else {
                    return self.player = AVPlayer()
                }
                let previewURL = URL(string: previewStr)
                guard let previewURL = previewURL else { return }
                self.playerItem = AVPlayerItem(url: previewURL)
                self.player?.replaceCurrentItem(with: self.playerItem)
            }
            .store(in: &subscriptions)

        //play next
        endOfSongSubscription = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: nil)
            .sink(receiveValue: { [weak self] _ in
                self?.fastFowardButtonTapped()
            })
    }

    func togglePlayback() {
        if player?.timeControlStatus == .playing {
            pause()
        } else {
            play()
        }
    }

    func rewindButtonTapped() {
        guard let tracks = currentPlayingTracks.value else { return }
        let currentTrackIndex = tracks.firstIndex { $0 == item.value }
        guard let currentTrackIndex else { return }
        if currentTrackIndex - 1 < 0 {
            item.send(tracks[tracks.count - 1])
        } else {
            item.send(tracks[currentTrackIndex - 1])
        }
    }

    func fastFowardButtonTapped() {
        guard let tracks = currentPlayingTracks.value else { return }
        let currentTrackIndex = tracks.firstIndex { $0 == item.value }
        guard let currentTrackIndex else { return }
        // 두 번 넘어가지 않게 예외 처리
        guard let currentItem = player?.currentItem, currentItem.status == .readyToPlay else { return }

        if currentTrackIndex + 1 > tracks.count - 1 {
            item.send(tracks[0])
        } else {
            item.send(tracks[currentTrackIndex + 1])
        }
    }

    private func pause() {
        player?.pause()
        isPlaying = false

    }

    func play() {
        player?.play()
        isPlaying = true
    }

    deinit {
        endOfSongSubscription?.cancel()
    }
}
