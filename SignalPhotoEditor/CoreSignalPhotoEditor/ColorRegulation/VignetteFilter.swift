//
//  VignetteFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct VignetteFilter: Regulation {
    
    var filterName: String = "Vignette"
    
    var value: Float = 0
    var minimumValue: Float = 0.0
    var maximumValue: Float = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.vignette()
        currentFilter.inputImage = image
        currentFilter.intensity = value
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
    }
}
