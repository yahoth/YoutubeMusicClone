//
//  HomeViewModel.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/28.
//

import UIKit
import Combine

final class HomeViewModel {

    ///input: User Interaction
    ///-
    ///output: Data 설정
    ///
    ///각 셀마다 데이터 설정해주기
    
    @Published var agains: [ListenAgain] = []
    let quickSelections = PassthroughSubject<[QuickSelection], Never>()
    let myStation = PassthroughSubject<MyStation, Never>()
    let customMixes = CurrentValueSubject<[CustomMix], Never>([])
    let playlistCard = PassthroughSubject<PlaylistCard, Never>()
    
    var subscriptions = Set<AnyCancellable>()
    
    let moreButtonTapped = PassthroughSubject<Int, Never>()
    
    let networkService: NetworkService
    
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

    @Published var accessToken = ""
    
    init(networkConfig: URLSessionConfiguration) {
        self.networkService = NetworkService(configuration: networkConfig)
    }
    
    func fetch() {
        myStation.send(MyStation.mock)
    }
    
    
    // accessToken이 받은지 1시간이 지나면 받아올 수 있도록 하는 메소드
    /// 받아온 기록이 없을 때 받아온다.
    /// 받아와서 저장해놓고 3600초 후 사라진다.
    ///
    
    func requestAccessToken() {
        let base: String = "https://accounts.spotify.com"
        let path: String = "/api/token"
        let params: [String: String] = [:]
        let header: [String: String] = ["Content-Type": "application/x-www-form-urlencoded"]
        let httpMethod = "POST"
        let request = Resource<SpotifyAccessToken>(base: base, path: path, params: params, header: header, httpMethod: httpMethod, clientID: clientID, clientSecret: clientSecret)
        
        networkService.load(request)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Request Access Token Error: \(error)")
                case .finished: break
                }
            } receiveValue: { token in
                let accessToken = "\(token.tokenType) \(token.accessToken)"
                print(accessToken)
                self.accessToken = accessToken
                self.fetchListenAgain(accessToken: accessToken)
                self.fetchCustomMix(accessToken: accessToken)
                self.fetchQuickSelection(accessToken: accessToken)
                self.fetchCardPlaylist(accessToken: accessToken)
            }.store(in: &subscriptions)
    }
    
    func fetchListenAgain(accessToken: String) {
        let base: String = "https://api.spotify.com"
        let path: String = "/v1/playlists/37i9dQZF1DX3ZeFHRhhi7Y/tracks"
        let params: [String: String] = [:]
        let header: [String: String] = ["Authorization": accessToken]
        let resource: Resource<PlaylistItemsResponse> = Resource(base: base, path: path, params: params, header: header)
        
        networkService.load(resource)
            .map({ first -> [ListenAgain] in
                let listenAgains = first.items.map { item in
                    let artist = item.track.album.artists[0].name
                    let image = item.track.album.images[0]
                    let title = item.track.name
                    let id = item.track.id
                    let song = ListenAgain(id: id, imageName: image.url, title: title, artist: artist)
                    return song
                }
                return listenAgains
            })
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("sink error: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { items in
                self.agains = items
            }.store(in: &subscriptions)
    }
    
    func fetchQuickSelection(accessToken: String) {
        let base: String = "https://api.spotify.com"
        let path: String = "/v1/playlists/0HqwnwTY7L4IYeg5iOcMsP/tracks"
        let params: [String: String] = [:]
        let header: [String: String] = ["Authorization": accessToken]
        let resource: Resource<PlaylistItemsResponse> = Resource(base: base, path: path, params: params, header: header)
        
        networkService.load(resource)
            .map({ first -> [QuickSelection] in
                let quickSelections = first.items.map { item in
                    let artist = item.track.album.artists[0].name
                    let image = item.track.album.images[0]
                    let title = item.track.name
                    let id = item.track.id
                    let song = QuickSelection(id: id, imageName: image.url, title: title, artist: artist)
                    return song
                }
                return quickSelections
            })
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("sink error: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { items in
                self.quickSelections.send(items)
            }.store(in: &subscriptions)
    }
    
    func fetchCustomMix(accessToken: String) {
        let base: String = "https://api.spotify.com"
        let path: String = "/v1/browse/featured-playlists"
        let params: [String: String] = [:]
        let header: [String: String] = ["Authorization": accessToken]
        let resource: Resource<FeaturedPlaylistResponse> = Resource(base: base, path: path, params: params, header: header)

        networkService.load(resource)
            .map({ response -> [CustomMix] in
                let customMixes = response.playlists.items.map { item in
                    let id = item.id
                    let description = item.description
                    let images = item.images
                    let name = item.name
                    
                    let song = CustomMix(id: id, description: description, images: images, name: name)
                    return song
                }
                return customMixes
            })
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("sink error: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { items in
                self.customMixes.send(items)
            }.store(in: &subscriptions)
    }
    // Playlist
    func fetchCardPlaylist(accessToken: String) {
        let base: String = "https://api.spotify.com"
        let path: String = "/v1/playlists/37i9dQZF1DWT1y71ZcMPe5"
        let params: [String: String] = [:]
        let header: [String: String] = ["Authorization": accessToken]
        let resource: Resource<PlaylistResponse> = Resource(base: base, path: path, params: params, header: header)
        
        networkService.load(resource)
            .map { response -> PlaylistCard in
                let id = response.id
                let title = response.name
                let imageName = response.images[0].url
                let description = response.description
                let tracks = response.tracks.items.map { item -> Track in
                    let id = item.track.id
                    let imageName = item.track.album.images[0].url
                    let title = item.track.name
                    let artist = item.track.album.artists[0].name
                    let releaseDate = item.track.album.releaseDate
                    
                    let song = Track(id: id, imageName: imageName, title: title, artist: artist, releaseDate: releaseDate)
                    
                    return song
                }
                let playlist = PlaylistCard(id: id, title: title, imageName: imageName, description: description, tracks: tracks)
                
                return playlist
            }.sink { completion in
                switch completion {
                case .failure(let error):
                    print("sink error: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { playlistCard in
                self.playlistCard.send(playlistCard)
            }.store(in: &subscriptions)
    }
}

