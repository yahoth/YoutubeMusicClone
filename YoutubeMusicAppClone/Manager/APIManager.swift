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

    let networkService: NetworkService

    init(networkConfig: URLSessionConfiguration) {
        self.networkService = NetworkService(configuration: networkConfig)
        requestAccessToken()
    }

    private var clientID: String {
      return infoPlistValue(forKey: "ClientID")
    }

    private var clientSecret: String {
      return infoPlistValue(forKey: "ClientSecret")
    }

    var subscriptions = Set<AnyCancellable>()

    @Published var accessToken: String?

    // MyStationDetail
    func fetchArtists(artists: PassthroughSubject<[RelatedArtistsResponse.Artists], Never>) {
        guard let accessToken else { return print("access token is nil")}

        let resource = Resource<RelatedArtistsResponse>(
            base: "https://api.spotify.com/",
            path: "v1/artists/6HvZYsbFfjnjFrWF950C9d/related-artists",
            params: [:],
            header: ["Authorization": accessToken]
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
                artists.send(items)
            }.store(in: &subscriptions)
    }

    func search(keyword: String) -> AnyPublisher<[AudioTrack], Error>{
        guard let accessToken else {
            return .fail(SpotifyError.invalidToken)
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
                    let imageName = item.album.images[0].url
                    let title = item.name
                    let artist = item.album.artists[0].name
                    let previewURL = item.previewURL
                    let duration = item.duration
                    let track = AudioTrack(id: id, imageName: imageName, title: title, artist: artist, previewURL: previewURL, duration: duration)
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
                self.accessToken = accessToken
            }.store(in: &subscriptions)
    }

    // Fetch Playlist item: ListeAgain, QuickSelection
    func fetchPlaylistItem(playlistID: String, tracks: CurrentValueSubject<[AudioTrack], Never>){
        guard let accessToken else { return print("access token is nil")}

        let base: String = "https://api.spotify.com"
        let path: String = "/v1/playlists/\(playlistID)/tracks"
        let params: [String: String] = [:]
        let header: [String: String] = ["Authorization": accessToken]
        let resource: Resource<PlaylistItemsResponse> = Resource(base: base, path: path, params: params, header: header)

        networkService.load(resource)
            .map { tracks in
                let tracks = tracks.items.map { item in
                    let artist = item.track.album.artists[0].name
                    let image = item.track.album.images[0]
                    let title = item.track.name
                    let id = item.track.id
                    let preview = item.track.previewURL
                    let duration = item.track.duration
                    let track = AudioTrack(id: id, imageName: image.url, title: title, artist: artist, previewURL: preview, duration: duration)

                    return track
                }
                return tracks
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
    func fetchPlaylistItemReverse(playlistID: String, tracks: CurrentValueSubject<[AudioTrack], Never>){
        guard let accessToken else { return print("access token is nil")}

        let base: String = "https://api.spotify.com"
        let path: String = "/v1/playlists/\(playlistID)/tracks"
        let params: [String: String] = [:]
        let header: [String: String] = ["Authorization": accessToken]
        let resource: Resource<PlaylistItemsResponse> = Resource(base: base, path: path, params: params, header: header)

        networkService.load(resource)
            .map { tracks in
                let tracks = tracks.items.map { item in
                    let artist = item.track.album.artists[0].name
                    let image = item.track.album.images[0]
                    let title = item.track.name
                    let id = item.track.id
                    let preview = item.track.previewURL
                    let duration = item.track.duration
                    let track = AudioTrack(id: id, imageName: image.url, title: title, artist: artist, previewURL: preview, duration: duration)

                    return track
                }
                return tracks
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
                tracks.send(items.reversed())
            }
            .store(in: &subscriptions)
    }

    // FeaturedPlaylists
    func fetchFeaturedPlaylists(playlist: CurrentValueSubject<[Playlist], Never>) {
        guard let accessToken else { return print("access token is nil")}

        let base: String = "https://api.spotify.com"
        let path: String = "/v1/browse/featured-playlists"
        let params: [String: String] = [:]
        let header: [String: String] = ["Authorization": accessToken]
        let resource: Resource<FeaturedPlaylistResponse> = Resource(base: base, path: path, params: params, header: header)

        networkService.load(resource)
            .map({ response -> [Playlist] in
                let playlists = response.playlists.items.map { item in
                    let id = item.id
                    let description = item.description
                    let images = item.images
                    let name = item.name

                    let track = Playlist(id: id, description: description, images: images, name: name)
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

    // Playlist
    func fetchPlaylist(playlist: PassthroughSubject<PlaylistCard, Never>) {
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
                    let imageName = item.track.album.images[0].url
                    let title = item.track.name
                    let artist = item.track.album.artists[0].name
                    let releaseDate = item.track.album.releaseDate
                    let previewURL = item.track.album.previewURL
                    let duration = item.track.album.duration

                    let track = AudioTrack(id: id, imageName: imageName, title: title, artist: artist, previewURL: previewURL, duration: duration)
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
}

extension APIManager {
    private func infoPlistValue(forKey: String) -> String {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: forKey) as? String else {
          fatalError("Couldn't find key '\(forKey)' in 'Info.plist'.")
        }
        return value
    }
}

