//
//  CustomRoundButton.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/10.
//

import UIKit

class CustomRoundButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }

    private func updateCornerRadius() {
        let buttonSize = min(bounds.width, bounds.height)
        layer.cornerRadius = buttonSize / 2
        clipsToBounds = true
    }
}
