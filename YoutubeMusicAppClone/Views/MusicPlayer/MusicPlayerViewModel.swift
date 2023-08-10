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

    var currentPlayingTracks = CurrentValueSubject<[AudioTrack]?, Never>([])

    var workItem: DispatchWorkItem?
    
    private init() {
        fetchPlayer()
    }

    func fetchPlayer() {
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
    }

    func playAndPauseButtonTapped(button: UIButton) {
        if player?.timeControlStatus == .playing {
            player?.pause()
            button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player?.play()
            button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
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
        if currentTrackIndex + 1 > tracks.count - 1 {
            item.send(tracks[0])
        } else {
            item.send(tracks[currentTrackIndex + 1])
        }

    }
    
    func pause() {
        player?.pause()

    }

    func play() {
        player?.play()
    }
}
