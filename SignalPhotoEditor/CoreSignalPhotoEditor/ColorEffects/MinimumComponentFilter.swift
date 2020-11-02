//
//  MinimumComponentFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct MinimumComponentFilter: Filter {
    
    var filterName: String? = "MinimumComponent"
    
    var intensity: Float = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.minimumComponent()
        currentFilter.inputImage = image
        applyIntensity(image: &image, filter: currentFilter)
 
    }
}
