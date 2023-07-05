//
//  SearchViewModel.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/03.
//

import Foundation
import Combine

final class SearchViewModel {
    
    let accessToken: String
    
    let networkService: NetworkService
    
    init(accessToken: String, networkConfig: URLSessionConfiguration) {
        self.accessToken = accessToken
        self.networkService = NetworkService(configuration: networkConfig)
    }
    let searchResults = PassthroughSubject<[SearchResponse.TracksItems], Never>()
    
    let searchButtonClicked = PassthroughSubject<[SearchResponse.TracksItems], Never>()
    
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
    
    func search(keyword: String) {
        let resource = Resource<SearchResponse>(
            base: "https://api.spotify.com/",
            path: "v1/search",
            params: ["q": keyword,
                     "type": "track"],
            header: ["Authorization": self.accessToken]
        )
        
        networkService.load(resource)
            .tryMap { searchResult in
                searchResult.tracks!.items
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("error: \(error)")
                case .finished: break
                }
            } receiveValue: { items -> Void in
//                print(items)
                self.searchResults.send(items)
            }.store(in: &subscriptions)
    }
    
    func searchClicked(keyword: String) {
        let resource = Resource<SearchResponse>(
            base: "https://api.spotify.com/",
            path: "v1/search",
            params: ["q": keyword,
                     "type": "track"],
            header: ["Authorization": self.accessToken]
        )
        
        networkService.load(resource)
            .tryMap { searchResult in
                searchResult.tracks!.items
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("error: \(error)")
                case .finished: break
                }
            } receiveValue: { items -> Void in
//                print(items)
                self.searchButtonClicked.send(items)
            }.store(in: &subscriptions)
    }

}
