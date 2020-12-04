//
//  SliderViewDelegate.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 03.12.2020.
//

import Foundation

protocol SliderViewDelegate: class {
    
    func sliderChangeValue(_ sliderNumber: Int, _ newValue: Int)
}
