//
//  SearchViewModel.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/03.
//

import Foundation
import Combine

final class SearchViewModel {
    var apiManager: APIManager

    let searchResults = PassthroughSubject<[AudioTrack], Never>()
    let searchButtonClicked = PassthroughSubject<[AudioTrack], Never>()

    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }

    func search(keyword: String) {
        apiManager.search(keyword: keyword, items: searchResults)
    }

    func searchButtonClicked(keyword: String) {
        apiManager.search(keyword: keyword, items: searchButtonClicked)
    }
}
