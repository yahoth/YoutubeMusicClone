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
                        VStack(alignment: .center) {
                            Text("No search results")
                        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.black).onTapGesture {
                            hideKeyboard()
                        }
                    } else if vm.searchState == .searching {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(vm.searchResults, id: \.uuid) { result in
                                    HStack(spacing: 20) {
                                        Image(systemName: "magnifyingglass")

                                        Text("\(result.artist) \(result.title)")
                                            .lineLimit(1)
//                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

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
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(vm.searchResults, id: \.uuid) { result in
                                    HStack(spacing: 16) {
                                        let imageURL = URL(string: result.imageName)
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
                    
                    Spacer()
                }
                .fullScreenCover(isPresented: $isPresented) {
                    let playerViewModel = MusicPlayerViewModel.shared
                    NavigationView {
                        MusicPlayerView(vm: playerViewModel)
                    }
                    .onAppear {
                        vm.$selectedAudioTrack.receive(on: RunLoop.main)
                            .sink { audioTrack in
                                playerViewModel.item.send(audioTrack)
                                playerViewModel.currentPlayingTracks.send(self.vm.searchResults)
                            }.store(in: &subscriptions)
                    }
                }
            }.navigationBarHidden(true)
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

    func makeUIViewController(context: Context) -> UIViewControllerType {
        let sb = UIStoryboard(name: "MusicPlayer", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
        vc.vm = self.vm
        let navigationController = UINavigationController(rootViewController: vc)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }

}
