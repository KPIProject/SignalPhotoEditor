//
//  SliderViewDelegate.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 03.12.2020.
//

import Foundation

protocol SliderViewDelegate: class {
    
    func slider(_ sliderModel: SliderModel, didChangeValue newValue: Int)
}
