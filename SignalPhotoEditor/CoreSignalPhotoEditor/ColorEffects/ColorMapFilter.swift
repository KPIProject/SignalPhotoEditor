//
//  ColorMapFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct ColorMapFilter: Filter {
    
    var filterName: String? = "ColorMap"
    
    var inputGradient: UIImage
    
    var intensity: Float = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.colorMap()
        currentFilter.inputImage = image

        guard let ciImage = CIImage(image: inputGradient) else { return }
        currentFilter.gradientImage = ciImage
        
        applyIntensity(image: &image, filter: currentFilter)
        // get a CIImage from our filter or exit if that fails
//        guard let outputImage = currentFilter.outputImage else { return }
        
//        image = outputImage
        
    }
    
}
