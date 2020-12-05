//
//  FilterCollectionModel.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 22.11.2020.
//

import UIKit

//struct FilterCollectionModel {
//
//    var image: UIImage
//    var filter: Filter
//    var firstSliderModel: SliderModel
//    var secondSliderModel: SliderModel? = nil
//    var thirdSliderModel: SliderModel? = nil
//}


struct FilterModel {
    
    var image: UIImage
//    var displayName: String
    var filter: GlobalFilter

//    var filtersFirst: (positiveFilter: Filter?, negativeFilter: Filter?)
//    var filtersSecond: (positiveFilter: Filter?, negativeFilter: Filter?)
    
    var slider: SliderModel {
        if filter is Filter {
            return SliderModel.positiveSliderMax
        } else {
            return filter.minimumValue == 0 ? .positiveSliderMin : .doubleSlider
        }
    }
}
