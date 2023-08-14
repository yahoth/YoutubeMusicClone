//
//  SearchBar.swift
//  SearchPractice
//
//  Created by TAEHYOUNG KIM on 2023/07/26.
//

import SwiftUI

struct SearchBar: View {
    @ObservedObject var vm: SearchViewModel
    var dismiss: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
            }

            TextField("노래, 앨범, 아티스트 검색", text: $vm.text) {
                vm.search(keyword: vm.text, searchState: .searchButtonClick)
            }
            .onChange(of: vm.text) { _ in
                if !vm.isTextEmpty {
                    vm.search(keyword: vm.text, searchState: .searching)
                }
            }
            .onTapGesture {
                vm.searchState = .searching
            }
            .padding(16)
            .frame(height: 36)
            .font(.body.bold())
            .background(Color(UIColor.darkGray))
            .cornerRadius(30)
            .overlay(
                HStack {
                    Spacer()
                    if vm.text.count > 0 {
                        Button {
                            vm.text = ""
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                        }.padding(.horizontal, 12)
                    }
                }
            )

            Button {
                //
            } label: {
                Image(systemName: "mic.fill")
            }

        }.foregroundColor(.white)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(vm: SearchViewModel(apiManager: APIManager(networkConfig: .default)), dismiss: {})
    }
}
