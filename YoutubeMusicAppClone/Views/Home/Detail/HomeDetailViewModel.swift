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

    var apiManager: APIManager

    init(with items: [AnyHashable], apiManager: APIManager) {
        self.items = items
        self.apiManager = apiManager
    }
}
