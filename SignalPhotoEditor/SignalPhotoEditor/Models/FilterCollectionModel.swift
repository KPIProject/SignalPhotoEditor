//
//  FilterCollectionModel.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 22.11.2020.
//

import UIKit

struct FilterCollectionModel {
    
    var image: UIImage
    var filter: Filter
    var firstSliderModel: SliderModel
    var secondSliderModel: SliderModel? = nil
    var thirdSliderModel: SliderModel? = nil
}
