//
//  MoreContentListViewModel.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/07.
//

import Foundation
import Combine

final class MoreContentListViewModel {
    
    @Published var items: [AnyHashable] = []

    init(with items: [AnyHashable]) {
        self.items = items
    }

    let didSelectItem = PassthroughSubject<AnyHashable, Never>()

    deinit {
        print("MoreViewModel Deinit")
    }
}
