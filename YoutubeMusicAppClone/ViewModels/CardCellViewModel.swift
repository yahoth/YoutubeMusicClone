//
//  CardCellViewModel.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/08/12.
//

import UIKit
import Combine

final class CardCellViewModel {
    var viewController: BaseViewController

    @Published var playlist: PlaylistCard
    
    init(viewController: BaseViewController, playlist: PlaylistCard) {
        self.viewController = viewController
        self.playlist = playlist
    }

    var tracks: [AudioTrack] {
        playlist.tracks
    }

    let didSelectItem = PassthroughSubject<AudioTrack, Never>()

    deinit {
        print("CardCell VM deinit")
    }

}
