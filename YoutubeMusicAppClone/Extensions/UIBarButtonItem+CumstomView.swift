//
//  UIBarButtonItem+CumstomView.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/23.
//

import UIKit

extension UIBarButtonItem {
    static func generate(config: CustomBarItemConfiguration, width: CGFloat? = nil, height: CGFloat? = nil) -> UIBarButtonItem {
        let customView = CustomBarItem(config: config)
        customView.imageView?.contentMode = .scaleAspectFit
        
        if let width = width {
            NSLayoutConstraint.activate([
                customView.widthAnchor.constraint(equalToConstant: width)
            ])
        }
        if let height = height {
            NSLayoutConstraint.activate([
                customView.heightAnchor.constraint(equalToConstant: height)
            ])
        }
        
        let barButtonItem = UIBarButtonItem(customView: customView)
        return barButtonItem
    }
}
