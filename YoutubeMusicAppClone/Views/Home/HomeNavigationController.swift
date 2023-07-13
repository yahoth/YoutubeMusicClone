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
        
        let backImage = UIImage(systemName: "arrow.backward")
        navigationBar.backIndicatorImage = backImage
        navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationBar.tintColor = .white
    }
}
