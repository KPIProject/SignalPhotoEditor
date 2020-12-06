//
//  FilterCollectionModel.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 22.11.2020.
//

import UIKit

struct FilterModel {
    
    var image: UIImage
    var filter: GlobalFilter
    
    var slider: SliderModel {
        if filter is Filter {
            return SliderModel.positiveSliderMax
        } else {
            return filter.minimumValue == 0 ? .positiveSliderMin : .doubleSlider
        }
    }
}
