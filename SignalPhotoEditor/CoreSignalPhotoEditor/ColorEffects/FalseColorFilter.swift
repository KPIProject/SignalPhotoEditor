//
//  FalseColorFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct FalseColorFilter: Filter {
    
    var filterName: String? = "FalseColor"
    
    var color0: CIColor
    var color1: CIColor
    
    var intensity: Float = 1.0
        
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.falseColor()
        currentFilter.color0 = color0
        currentFilter.color1 = color1
        
        applyIntensity(image: &image, filter: currentFilter)
        
        // get a CIImage from our filter or exit if that fails
//        guard let outputImage = currentFilter.outputImage else { return }
        
//        image = outputImage
        
    }
}


