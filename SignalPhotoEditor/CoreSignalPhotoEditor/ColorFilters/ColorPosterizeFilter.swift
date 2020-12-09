//
//  ColorPosterizeFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct ColorPosterizeFilter: Filter {
    
    var filterName: String = "Posterize"
    var level: Float = 6.0
    var value: Float = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.colorPosterize()
        currentFilter.levels = level
        currentFilter.inputImage = image
        
        applyIntensity(image: &image, filter: currentFilter)
    }
}
