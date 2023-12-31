//
//  SearchViewModel.swift
//  SearchPractice
//
//  Created by TAEHYOUNG KIM on 2023/07/26.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {

    let apiManager: APIManager = APIManager.shared

    enum SearchState {
        case searching
        case suggestedClick
        case searchButtonClick
        case searchCompleted
    }

    var subscriptions = Set<AnyCancellable>()

    @Published var searchState: SearchState = .searching

    @Published var text = ""

    var isTextEmpty: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 ? false : true
    }

    @Published var selectedAudioTrack: AudioTrack?
    @Published var searchResults: [AudioTrack] = []

    func search(keyword: String, searchState: SearchState) {
        if !isTextEmpty {

            apiManager.search(keyword: keyword)
                .receive(on: RunLoop.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print("sink error: \(error)")
                    case .finished:
                        break
                    }
                } receiveValue: { tracks in
                    self.searchResults = tracks

                    if searchState != .searching {
                        self.searchState = .searchCompleted
                    }
                }
                .store(in: &subscriptions)
        }
        self.text = keyword
    }

    deinit {
        print("SearchViewModel Deinit")
    }
}
