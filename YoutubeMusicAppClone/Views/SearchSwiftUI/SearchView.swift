//
//  SearchView.swift
//  SearchPractice
//
//  Created by TAEHYOUNG KIM on 2023/07/26.
//

import SwiftUI
import Combine

import Kingfisher

struct SearchView: View {
    @StateObject var vm: SearchViewModel
    @State var isPresented = false
    @State var subscriptions = Set<AnyCancellable>()
    var dismiss: () -> Void

    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 20) {
                    SearchBar(vm: vm, dismiss: dismiss)
                        .padding(8)

                    if vm.isTextEmpty {
                        searchEntryView()
                    } else if vm.searchState == .searching {
                        searchSuggestionView()
                    } else {
                        searchResultsView()
                    }

                    Spacer()
                }
                .fullScreenCover(isPresented: $isPresented) {
                    let playerViewModel = MusicPlayerViewModel.shared
                    NavigationView {
                        MusicPlayerView(vm: playerViewModel)
                    }
                    .onAppear {
                        playerViewModel.item.send(vm.selectedAudioTrack)
                        playerViewModel.currentPlayingTracks.send(vm.searchResults)
                    }
                }
            }.navigationBarHidden(true)
        }
    }

    @ViewBuilder
    func searchEntryView() -> some View {
        VStack(alignment: .center) {
            Text("No search results")
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.black).onTapGesture {
            hideKeyboard()
        }
    }

    func searchSuggestionView() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(vm.searchResults, id: \.uuid) { result in
                    HStack(spacing: 20) {
                        Image(systemName: "magnifyingglass")

                        Text("\(result.artist) \(result.title)")
                            .lineLimit(1)

                        Spacer()

                        Image(systemName: "arrow.up.left")
                    }
                    .padding(20)
                    .background(Color.black)
                    .onTapGesture {
                        vm.search(keyword: "\(result.artist) \(result.title)", searchState: .suggestedClick)
                        hideKeyboard()
                    }
                }
            }
        }
    }

    func searchResultsView() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(vm.searchResults, id: \.uuid) { result in
                    HStack(spacing: 16) {
                        let imageURL = URL(string: result.images[2].url)
                        KFImage(imageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)

                        VStack(alignment: .leading) {
                            Text(result.title)
                                .lineLimit(2)
                                .font(.body.weight(.bold))
                            Text("\(result.artist) • \(result.FormattedDurationTime)")
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        Image(systemName: "ellipsis")
                            .rotationEffect(Angle(degrees: 90))
                    }
                    .onTapGesture {
                        vm.selectedAudioTrack = result
                        isPresented.toggle()
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(vm: SearchViewModel(), dismiss: {})
            .preferredColorScheme(.dark)
    }
}

struct MusicPlayerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController
    var vm: MusicPlayerViewModel

    init(vm: MusicPlayerViewModel) {
        self.vm = vm
    }

    func makeUIViewController(context: Context) -> UIViewControllerType {
        let sb = UIStoryboard(name: "MusicPlayer", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
        vc.vm = vm
        let navigationController = UINavigationController(rootViewController: vc)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
}
