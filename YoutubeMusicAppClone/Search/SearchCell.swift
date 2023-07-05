//
//  SearchCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/03.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
    @IBOutlet weak var searchResultLabel: UILabel!
    
    func configure(item: SearchResponse.TracksItems) {
        searchResultLabel.text = "\(item.album.artists[0].name)  \(item.name)"
    }
}
