//
//  CustomBarItem.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/23.
//

import UIKit

class CustomBarItemConfiguration {
    typealias Handler = () -> Void
    let title: String?
    let image: UIImage?
    let handler: Handler
    
    init(title: String? = nil, image: UIImage? = nil, handler: @escaping Handler) {
        self.title = title
        self.image = image
        self.handler = handler
    }
}

final class CustomBarItem: UIButton {
    let cumstomBarItemConfig: CustomBarItemConfiguration
    
    init(config: CustomBarItemConfiguration) {
        self.cumstomBarItemConfig = config
        super.init(frame: .zero)
        setupStyle()
        updateConfig()
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    private func setupStyle() {
        self.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        self.setTitleColor(.white, for: .normal)
        self.imageView?.tintColor = .white
    }
    
    private func updateConfig() {
        self.setTitle(cumstomBarItemConfig.title, for: .normal)
        self.setImage(cumstomBarItemConfig.image, for: .normal)
    }
    
    @objc func buttonTapped() {
        cumstomBarItemConfig.handler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
