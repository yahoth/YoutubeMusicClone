//
//  MusicPlayerViewModel.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/10.
//

import Foundation
import AVFoundation
import Combine

final class MusicPlayerViewModel {
    let player = AVPlayer()
    var playerItem: AVPlayerItem?
    var timeObserverToken: AnyObject?

    let item = CurrentValueSubject<AudioTrack?, Never>(nil)
    var subscriptions = Set<AnyCancellable>()

    init() {
        fetchPlayer()
    }

    func fetchPlayer() {
        item.receive(on: RunLoop.main)
            .sink { item in
                    let previewURL = URL(string: item?.preview_url ?? "")
                    guard let previewURL = previewURL else { return }
                    self.playerItem = AVPlayerItem(url: previewURL)
                    self.player.replaceCurrentItem(with: self.playerItem)
            }
            .store(in: &subscriptions)
    }

    func playAndPause() {
        if player.timeControlStatus == .paused {
            player.play()
        } else {
            player.pause()
        }
    }

    func pause() {
        player.pause()
    }

    func playAfter2Seconds() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.player.play()
        }
    }
    
}
