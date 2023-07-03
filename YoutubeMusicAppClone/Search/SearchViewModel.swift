//
//  SearchViewModel.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/03.
//

import Foundation
import Combine

final class SearchViewModel {
    
    private let accessToken: String
    
    let networkService: NetworkService
    
    init(accessToken: String, networkConfig: URLSessionConfiguration) {
        self.accessToken = accessToken
        self.networkService = NetworkService(configuration: networkConfig)
    }
    
    var subscriptions = Set<AnyCancellable>()
    
    private var clientID: String {
      get {
        // 1
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Info.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "ClientID") as? String else {
          fatalError("Couldn't find key 'ClientID' in 'Info.plist'.")
        }
        return value
      }
    }
    
    private var clientSecret: String {
      get {
        // 1
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Info.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "ClientSecret") as? String else {
          fatalError("Couldn't find key 'ClientSecret' in 'Info.plist'.")
        }
        return value
      }
    }

    let searchResult = PassthroughSubject<SearchResult, Never>()
    
    func search(keyword: String) {

        let resource = Resource<SearchResult>(
            base: "https://api.spotify.com/",
            path: "v1/search",
            params: ["p": keyword,
                     "type": "artist"],
            header: ["Authorization": accessToken]
        )
        
        networkService.load(resource)
            .map { searchResult in
                searchResult.artists.items
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("error: \(error)")
                case .finished: break
                }
            } receiveValue: { items in
                print("토큰:\(self.accessToken)")

                print(items)
            }.store(in: &subscriptions)

    }
    
}
