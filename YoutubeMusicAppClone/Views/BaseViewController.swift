//
//  BaseViewController.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/08/14.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func presentMusicPlayer(with item: Any, tracks: [AudioTrack]) {
        guard let audioTrack = item as? AudioTrack else { return }
        let sb = UIStoryboard(name: "MusicPlayer", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
        vc.vm = MusicPlayerViewModel.shared
        vc.vm?.currentPlayingTracks.send(tracks)
        vc.vm?.item.send(audioTrack)
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}
