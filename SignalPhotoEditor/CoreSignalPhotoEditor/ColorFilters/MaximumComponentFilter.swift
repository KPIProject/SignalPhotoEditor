//
//  MaximumComponentFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct MaximumComponentFilter: Filter {
    
    var filterName: String = "Max"
    var value: Float = 1
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.maximumComponent()
        currentFilter.inputImage = image
        
        applyIntensity(image: &image, filter: currentFilter)
    }
}
