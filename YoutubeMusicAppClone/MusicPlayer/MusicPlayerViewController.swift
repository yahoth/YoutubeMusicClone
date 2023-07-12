//
//  MusicPlayerViewController.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/07.
//

import UIKit
import Kingfisher
import Combine

class MusicPlayerViewController: UIViewController {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var thumbDownButton: UIButton!
    @IBOutlet weak var thumbUpButton: UIButton!
    @IBOutlet weak var progressBar: UISlider!

    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var fastforwardButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!

    var vm: MusicPlayerViewModel!
    var apiManager: APIManager!
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupSlider()
        setNavigationItem()
        vm.play()
    }

    private func setNavigationItem() {
        let closeViewImage = UIImage(systemName: "chevron.down")
        let closeViewConfig = CustomBarItemConfiguration(image: closeViewImage) {
            self.vm.play()
            self.dismiss(animated: true)
        }
        let closeViewItem = UIBarButtonItem.generate(config: closeViewConfig)
        navigationItem.leftBarButtonItems = [closeViewItem]
    }

    private func setupSlider() {
        let normalConfig = UIImage.SymbolConfiguration(pointSize: 12)
        let highlightedConfig = UIImage.SymbolConfiguration(pointSize: 20)

        let normalThumb = UIImage(systemName: "circle.fill", withConfiguration: normalConfig)
        let highlightedThumb = UIImage(systemName: "circle.fill", withConfiguration: highlightedConfig)

        progressBar.setThumbImage(normalThumb, for: .normal)
        progressBar.setThumbImage(highlightedThumb, for: .highlighted)
    }

    private func bind() {
        vm.item.receive(on: RunLoop.main)
            .compactMap {$0}
            .sink { item in
                self.configure(item: item)
                print(item)
            }.store(in: &subscriptions)
    }

    private func configure(item: ListenAgain) {
        let imageURL = URL(string: item.imageName)
        thumbnailImageView.kf.setImage(with: imageURL)
        titleLabel.text = item.title
        artistLabel.text = item.artist
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        playButton.setImage(UIImage(systemName: "play.fill"), for: .selected)
//        playButton.backgroundColor = .clear
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        vm.play()
        playButton.isSelected.toggle()
        print(playButton.isSelected)
    }

    @IBAction func rewindButtonTapped(_ sender: Any) {
        let tracks = apiManager.agains
        let currentTrackIndex = tracks.firstIndex { $0 == vm.item.value }
        guard let currentTrackIndex else { return }
    }

    @IBAction func fastFowardButtonTapped(_ sender: Any) {

    }

}
