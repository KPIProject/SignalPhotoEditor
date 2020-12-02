//
//  VignetteFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct VignetteFilter: Filter {
    
    var filterName: String? = "Vignette"
    
    var intensity: Float?
    
    var radius: Float = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.vignette()
        currentFilter.inputImage = image
        currentFilter.intensity = intensity ?? 0.0
        currentFilter.radius = radius
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
        
    }
    
}
