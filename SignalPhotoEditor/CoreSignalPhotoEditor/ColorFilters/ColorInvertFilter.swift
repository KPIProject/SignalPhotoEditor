//
//  ColorInvertFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct ColorInvertFilter: Filter {
    
    var intensity: Float? = 1.0
    
    var filterName: String = "Invert"
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.colorInvert()
        currentFilter.inputImage = image
        
        applyIntensity(image: &image, filter: currentFilter)
        
    }
    
}

