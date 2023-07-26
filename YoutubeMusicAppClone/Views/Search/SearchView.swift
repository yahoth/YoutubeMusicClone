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
    @State var subscriptions = Set<AnyCancellable>()
    var dismiss: () -> Void

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    SearchBar(vm: vm, dismiss: dismiss)
                        .padding(.horizontal, 8)

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: vm.searchState == .searching ? 32 : 16) {
                            if !vm.isTextEmpty {
                                ForEach(vm.searchResults, id: \.uuid) { result in
                                    let keyword = "\(result.artist) \(result.title)"
                                    if vm.searchState == .searching {
                                        HStack(spacing: 20) {
                                            Image(systemName: "magnifyingglass")

                                            Text(keyword)
                                                .lineLimit(1)

                                            Spacer()

                                            Image(systemName: "arrow.up.left")
                                        }
                                        .onTapGesture {
                                            vm.search(keyword: keyword, searchState: .suggestedClick)
                                        }
                                    } else {
                                        HStack(spacing: 16) {
                                            let imageURL = URL(string: result.imageName)
                                            KFImage(imageURL)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 60, height: 60)

                                            VStack(alignment: .leading) {
                                                Text(result.title)
                                                    .lineLimit(2)
                                                Text("\(result.artist) • \(result.FormattedDurationTime)")
                                                    .foregroundColor(.gray)
                                            }

                                            Spacer()

                                            Image(systemName: "ellipsis")
                                                .rotationEffect(Angle(degrees: 90))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)

                    Spacer()
                }
            }.navigationBarHidden(true)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(vm: SearchViewModel(apiManager: APIManager(networkConfig: .default)), dismiss: {})
            .preferredColorScheme(.dark)
    }
}
