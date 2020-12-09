//
//  FilterCollectionViewCell.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 22.11.2020.
//

import UIKit

final class FilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    }
}
