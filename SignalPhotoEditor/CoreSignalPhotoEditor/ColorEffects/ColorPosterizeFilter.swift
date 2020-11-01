//
//  ColorPosterizeFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct ColorPosterizeFilter: Filter {
    
    var filterName: String? = "ColorPosterize"
    
    var level: Float = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.colorPosterize()
        currentFilter.levels = level
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
        
    }
}
