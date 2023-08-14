//
//  UIView+FindViewController.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/08/14.
//

import UIKit

extension UIView {
    func findViewController() -> UIViewController? {
        if let controller = next as? UIViewController {
            return controller
        } else if let view = next as? UIView {
            return view.findViewController()
        } else {
            return nil
        }
    }
}
