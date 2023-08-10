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
        setupAudioSession()
        bind()
        configurePlaybackSlider()
        setNavigationItem()
    }

    @IBAction func playbackSliderValueChaged(_ sender: UISlider) {
        let currentTime = CMTime(seconds: Double(sender.value), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        vm.player?.seek(to: currentTime)
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
        let currentTime = CMTimeGetSeconds(vm.player?.currentTime() ?? CMTime())
        playbackSlider.value = Float(currentTime)
        updateCurrentTimeLabel()
        updateDurationTimeLabel()
    }

    func setupTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        vm.timeObserverToken = vm.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            self?.updateSliderAndLabel()
        } as AnyObject
    }

    func removeTimeObserver() {
        if let token = vm.timeObserverToken {
            vm.player?.removeTimeObserver(token)
            vm.timeObserverToken = nil
        }
        print("remove")
    }

    func updateCurrentTimeLabel() {
        let currentTime = CMTimeGetSeconds(vm.player?.currentTime() ?? CMTime())

        if isValueValid(value: Float(currentTime)) {
            let currentTime = Int(CMTimeGetSeconds(vm.player?.currentTime() ?? CMTime()))
            let minutes = currentTime / 60
            let seconds = currentTime % 60
            currentTimeLabel.text = String(format: "%02d:%02d", minutes, seconds)
        } else {
            currentTimeLabel.text = "00:00"
        }
    }

    func updateDurationTimeLabel() {
        let durationTime = Int(CMTimeGetSeconds(vm.playerItem?.asset.duration ?? CMTime()))
        let minutes = durationTime / 60
        let seconds = durationTime % 60
        durationLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    func isValueValid(value: Float) -> Bool {
        return value > 0 && !value.isNaN
    }

    private func setupPlaybackSlider() {
        let assetDuration = vm.playerItem?.asset.duration
        playbackSlider.minimumValue = 0

        let maximauValue = Float(CMTimeGetSeconds(assetDuration ?? CMTime()))
        playbackSlider.maximumValue = isValueValid(value: maximauValue) ? maximauValue : 100
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

    //Mute 모드일 때도 재생가능
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()

            // Set the audio session category
            try audioSession.setCategory(.playback, options: .duckOthers)

            // Activate the audio session
            try audioSession.setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }

    private func bind() {
        vm.item.receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { item in
                self.configure(item: item)
                self.setupPlaybackSlider()
                self.setupTimeObserver()
                self.vm.play()
            }.store(in: &subscriptions)
    }

    private func configure(item: AudioTrack) {
        let imageURL = URL(string: item.imageName)
        thumbnailImageView.kf.setImage(with: imageURL)
        titleLabel.text = item.title
        artistLabel.text = item.artist
        playAndPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }

    @IBAction func playAndPauseButtonTapped(_ sender: Any) {
        vm.playAndPauseButtonTapped(button: playAndPauseButton)
    }

    @IBAction func rewindButtonTapped(_ sender: Any) {
        vm.rewindButtonTapped()
    }

    @IBAction func fastFowardButtonTapped(_ sender: Any) {
        vm.fastFowardButtonTapped()
    }

    deinit {
        removeTimeObserver()
        print("deinit")
    }
}
