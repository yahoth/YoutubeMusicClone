//
//  HomeDetailViewModel.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/07.
//

import Foundation
import Combine

final class HomeDetailViewModel {
    
    @Published var items: [AnyHashable] = []
    
    init(inputItems: [AnyHashable]) {
        self.items = inputItems
    }
}
