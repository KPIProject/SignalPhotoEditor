//
//  MaximumComponentFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct MaximumComponentFilter: Filter {
    
    var filterName: String? = "MaximumComponent"
    
    var intensity: Float? = 0.5
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.maximumComponent()
        currentFilter.inputImage = image
        
        applyIntensity(image: &image, filter: currentFilter)
        
    }
}



