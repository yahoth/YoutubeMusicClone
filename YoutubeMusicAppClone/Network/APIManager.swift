//
//  APIManager.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/12.
//

import Foundation
import Combine

enum SpotifyError: Error {
    case invalidToken
}

final class APIManager {

    static let shared = APIManager(networkConfig: .default)
    
    let networkService: NetworkService

    init(networkConfig: URLSessionConfiguration) {
        self.networkService = NetworkService(configuration: networkConfig)
        requestAccessToken()
    }

//    private var clientID: String {
//      return infoPlistValue(forKey: "ClientID")
//    }

//    private var clientSecret: String {
//      return infoPlistValue(forKey: "ClientSecret")
//    }

    var subscriptions = Set<AnyCancellable>()

    @Published var accessToken: String?

    // YourMusicTunerDetail
    func fetchArtists() -> AnyPublisher<[RelatedArtistsResponse.Artists], Error> {
        guard let accessToken else {
            return Fail(error: SpotifyError.invalidToken).eraseToAnyPublisher()
        }

        let resource = Resource<RelatedArtistsResponse>(
            base: "https://api.spotify.com/",
            path: "v1/artists/6HvZYsbFfjnjFrWF950C9d/related-artists",
            params: [:],
            header: ["Authorization": accessToken]
        )

        return networkService.load(resource)
            .compactMap { response in
                response.artists
            }
            .eraseToAnyPublisher()
    }

    func search(keyword: String) -> AnyPublisher<[AudioTrack], Error>{
        guard let accessToken else {
            return Fail(error: SpotifyError.invalidToken).eraseToAnyPublisher()
        }

        let resource = Resource<SearchResponse>(
            base: "https://api.spotify.com/",
            path: "v1/search",
            params: ["q": keyword,
                     "type": "track"],
            header: ["Authorization": accessToken]
        )

        return networkService.load(resource)
            .map { searchResult in
                let tracks = searchResult.tracks.items.map { item in

                    let id = item.id
                    let images = item.album.images
                    let title = item.name
                    let artist = item.album.artists[0].name
                    let previewURL = item.previewURL
                    let duration = item.duration
                    let track = AudioTrack(id: id, images: images, title: title, artist: artist, previewURL: previewURL, duration: duration)
                    return track
                }
                return tracks
            }
            .eraseToAnyPublisher()
    }

    func requestAccessToken() {
        let base: String = "https://accounts.spotify.com"
        let path: String = "/api/token"
        let params: [String: String] = [:]
        let header: [String: String] = ["Content-Type": "application/x-www-form-urlencoded"]
        let request = Resource<SpotifyAccessToken>(base: base, path: path, params: params, header: header, httpMethod: "POST", clientID: clientID, clientSecret: clientSecret)

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
                self.accessToken = accessToken
            }.store(in: &subscriptions)
    }

    // Fetch Playlist item: ListeAgain, QuickPicks, PlaylistDetail(MixedForYou)
    func fetchPlaylistItem(playlistID: String, tracks: CurrentValueSubject<[AudioTrack], Never>){
        guard let accessToken else { return print("access token is nil")}

        let base: String = "https://api.spotify.com"
        let path: String = "/v1/playlists/\(playlistID)/tracks"
        let params: [String: String] = [:]
        let header: [String: String] = ["Authorization": accessToken]
        let resource: Resource<PlaylistItemsResponse> = Resource(base: base, path: path, params: params, header: header)

        networkService.load(resource)
            .map { response -> [AudioTrack] in
                return response.items.compactMap {
                    guard let track = $0.track else { return nil }
                    let artist = track.album.artists[0].name
                    let images = track.album.images
                    let title = track.name
                    let id = track.id
                    let preview = track.previewURL
                    let duration = track.duration

                    let audioTrack = AudioTrack(id: id, images: images, title: title, artist: artist, previewURL: preview, duration: duration)
                    return audioTrack
                }
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("sink error: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { items in
                tracks.send(items)
            }
            .store(in: &subscriptions)
    }

    // FeaturedPlaylists
    func fetchFeaturedPlaylists(playlist: CurrentValueSubject<[PlaylistInfo], Never>) {
        guard let accessToken else { return print("access token is nil")}

        let base: String = "https://api.spotify.com"
        let path: String = "/v1/browse/featured-playlists"
        let params: [String: String] = [:]
        let header: [String: String] = ["Authorization": accessToken]
        let resource: Resource<FeaturedPlaylistResponse> = Resource(base: base, path: path, params: params, header: header)

        networkService.load(resource)
            .map({ response -> [PlaylistInfo] in
                let playlists = response.playlists.items.map { item in
                    let id = item.id
                    let description = item.description
                    let imageName = item.images[0].url
                    let title = item.name

                    let track = PlaylistInfo(id: id, description: description, imageName: imageName, title: title)
                    return track
                }
                return playlists
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
                    playlist.send(items)
            }.store(in: &subscriptions)
    }

    // PlaylistInfo
    func fetchPlaylist(playlist: CurrentValueSubject<PlaylistCard?, Never>) {
        guard let accessToken else { return print("access token is nil")}

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
                let tracks = response.tracks.items.map { item -> AudioTrack in
                    let id = item.track.id
                    let images = item.track.album.images
                    let title = item.track.name
                    let artist = item.track.album.artists[0].name
                    let previewURL = item.track.previewURL
                    let duration = item.track.duration

                    let track = AudioTrack(id: id, images: images, title: title, artist: artist, previewURL: previewURL, duration: duration)
                    return track
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
            } receiveValue: { items in
                playlist.send(items)
            }.store(in: &subscriptions)
    }
    deinit {
        print("APIManager deinit")
    }

}

extension APIManager {
//    private func infoPlistValue(forKey: String) -> String {
//        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
//          fatalError("Couldn't find file 'Info.plist'.")
//        }
//        let plist = NSDictionary(contentsOfFile: filePath)
//        guard let value = plist?.object(forKey: forKey) as? String else {
//          fatalError("Couldn't find key '\(forKey)' in 'Info.plist'.")
//        }
//        return value
//    }

}

