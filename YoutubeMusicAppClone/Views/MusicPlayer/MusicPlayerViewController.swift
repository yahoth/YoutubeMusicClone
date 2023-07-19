//
//  MusicPlayerViewController.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/07.
//

import UIKit
import Kingfisher
import Combine
import AVFoundation

class MusicPlayerViewController: UIViewController {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var thumbDownButton: UIButton!
    @IBOutlet weak var thumbUpButton: UIButton!
    @IBOutlet weak var playbackSlider: UISlider!

    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var playAndPauseButton: UIButton!
    @IBOutlet weak var fastforwardButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!

    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    var vm: MusicPlayerViewModel!
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupPlaybackSlider()
        configurePlaybackSlider()
        setNavigationItem()
        setupTimeObserver()
    }

    @IBAction func playbackSliderValueChaged(_ sender: UISlider) {
        let currentTime = CMTime(seconds: Double(sender.value), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        vm.player.seek(to: currentTime)
        updateCurrentTimeLabel()
    }

    private func setNavigationItem() {
        let closeViewImage = UIImage(systemName: "chevron.down")
        let closeViewConfig = CustomBarItemConfiguration(image: closeViewImage) {
            self.vm.pause()
            self.dismiss(animated: true)
        }
        let closeViewItem = UIBarButtonItem.generate(config: closeViewConfig)
        navigationItem.leftBarButtonItems = [closeViewItem]
    }

    @objc func updateSliderAndLabel() {
        let currentTime = CMTimeGetSeconds(vm.player.currentTime())
        playbackSlider.value = Float(currentTime)
        updateCurrentTimeLabel()
        updateDurationTimeLabel()
    }

    func setupTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        vm.timeObserverToken = vm.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            self?.updateSliderAndLabel()
        } as AnyObject
    }

    func removeTimeObserver() {
        if let token = vm.timeObserverToken {
            vm.player.removeTimeObserver(token)
            vm.timeObserverToken = nil
        }
        print("remove")
    }

    func updateCurrentTimeLabel() {
        let currentTime = Int(CMTimeGetSeconds(vm.player.currentTime()))
        let minutes = currentTime / 60
        let seconds = currentTime % 60
        currentTimeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    func updateDurationTimeLabel() {
        let durationTime = Int(CMTimeGetSeconds(vm.playerItem?.asset.duration ?? CMTime()))
        let minutes = durationTime / 60
        let seconds = durationTime % 60
        durationLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }


    private func setupPlaybackSlider() {
        let assetDuration = vm.playerItem?.asset.duration
        playbackSlider.maximumValue = Float(CMTimeGetSeconds(assetDuration ?? CMTime()))
        playbackSlider.value = 0
    }

    private func configurePlaybackSlider() {
        let normalConfig = UIImage.SymbolConfiguration(pointSize: 12)
        let highlightedConfig = UIImage.SymbolConfiguration(pointSize: 20)

        let normalThumb = UIImage(systemName: "circle.fill", withConfiguration: normalConfig)
        let highlightedThumb = UIImage(systemName: "circle.fill", withConfiguration: highlightedConfig)

        playbackSlider.setThumbImage(normalThumb, for: .normal)
        playbackSlider.setThumbImage(highlightedThumb, for: .highlighted)
    }

    private func bind() {
        vm.item.receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { item in
                self.configure(item: item)
                self.vm.playAfter2Seconds()
            }.store(in: &subscriptions)
    }

    private func configure(item: AudioTrack) {
        let imageURL = URL(string: item.imageName)
        thumbnailImageView.kf.setImage(with: imageURL)
        titleLabel.text = item.title
        artistLabel.text = item.artist
        playAndPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        playAndPauseButton.setImage(UIImage(systemName: "play.fill"), for: .selected)
    }

    @IBAction func playAndPauseButtonTapped(_ sender: Any) {
        vm.playAndPause()
        playAndPauseButton.isSelected.toggle()
    }

    @IBAction func rewindButtonTapped(_ sender: Any) {
        vm.pause()
        vm.playAfter2Seconds()
        guard let tracks = vm.currentPlayingTracks.value else { return }
        let currentTrackIndex = tracks.firstIndex { $0 == vm.item.value }
        guard let currentTrackIndex else { return }
        if currentTrackIndex - 1 < 0 {
            vm.item.send(tracks[tracks.count - 1])
        } else {
            vm.item.send(tracks[currentTrackIndex - 1])
        }
    }

    @IBAction func fastFowardButtonTapped(_ sender: Any) {
        vm.pause()
        vm.playAfter2Seconds()
        guard let tracks = vm.currentPlayingTracks.value else { return }
        let currentTrackIndex = tracks.firstIndex { $0 == vm.item.value }
        guard let currentTrackIndex else { return }
        if currentTrackIndex + 1 > tracks.count - 1 {
            vm.item.send(tracks[0])
        } else {
            vm.item.send(tracks[currentTrackIndex + 1])
        }
    }

    deinit {
        removeTimeObserver()
        print("deinit")
    }

}
