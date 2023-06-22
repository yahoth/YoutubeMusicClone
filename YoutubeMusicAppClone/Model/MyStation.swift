//
//  MyStation.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/22.
//

import Foundation

struct MyStation: Hashable, Identifiable {
    let id = UUID()
    let myStation: String
}

extension MyStation {
    static let mock = MyStation(myStation: "My Station")
}
