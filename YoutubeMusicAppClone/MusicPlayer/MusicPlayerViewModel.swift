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

  let item = CurrentValueSubject<ListenAgain?, Never>(nil)

  init() {
    self.playerItem = AVPlayerItem(url: tempURL)
    player.replaceCurrentItem(with: self.playerItem)
  }

  let tempURL = URL(string: "https://p.scdn.co/mp3-preview/dab062e2cc708a2680ce84953a3581c5a679a230?cid=0b297fa8a249464ba34f5861d4140e58")!

  func play() {
      if player.timeControlStatus == .paused {
        player.play()
      } else {
        player.pause()
      }
  }
}
