//
//  MyStationDetailViewModel.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/06.
//

import Foundation
import Combine

final class MyStationDetailViewModel {
    
    let accessToken: String

    let networkService: NetworkService
    
    let artists = PassthroughSubject<[RelatedArtistsResponse.Artists], Never>()
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

    init(accessToken: String, networkConfig: URLSessionConfiguration) {
        self.accessToken = accessToken
        self.networkService = NetworkService(configuration: networkConfig)
    }

    func fetch() {
        let resource = Resource<RelatedArtistsResponse>(
            base: "https://api.spotify.com/",
            path: "v1/artists/6HvZYsbFfjnjFrWF950C9d/related-artists",
            params: [:],
            header: ["Authorization": self.accessToken]
        )
        
        networkService.load(resource)
            .compactMap { response in
                response.artists
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("error: \(error)")
                case .finished: break
                }
            } receiveValue: { items in
                self.artists.send(items)
            }.store(in: &subscriptions)
    }
}
