//
//  HomeNavigationController.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/22.
//

import UIKit

class HomeNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImage = UIImage(systemName: "chevron.left")
        let backImageConfig = UIImage.SymbolConfiguration(scale: .medium)
        if let resizedImage =  backImage?.applyingSymbolConfiguration(backImageConfig) {
            navigationBar.backIndicatorImage = resizedImage
            navigationBar.backIndicatorTransitionMaskImage = resizedImage
        }
        navigationBar.tintColor = .white
    }
}
