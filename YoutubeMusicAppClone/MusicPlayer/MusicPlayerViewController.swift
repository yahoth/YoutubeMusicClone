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
  var subscriptions = Set<AnyCancellable>()

  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
    setupSlider()
    vm.play()
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
  }

  @IBAction func playButtonTapped(_ sender: Any) {

    vm.play()
    
  }
}
