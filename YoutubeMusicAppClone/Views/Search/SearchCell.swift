//
//  SearchCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/03.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
    @IBOutlet weak var searchResultLabel: UILabel!
    
    func configure(item: AudioTrack) {
        searchResultLabel.text = "\(item.artist)  \(item.title)"
    }
}
