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
    var maximumValue: Float = 2.0
    
    func applyFilter(image: inout CIImage) {
        
        
        
        let currentFilter = CIFilter.vignette()
        currentFilter.inputImage = image
        currentFilter.intensity = value
        
        let base = Double(sqrt(pow(image.extent.width, 2) + pow(image.extent.height, 2)))
        let c = base / 20
        currentFilter.radius = Float(c) * value / maximumValue
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else {
            return
        }
        
        image = outputImage
    }
}
