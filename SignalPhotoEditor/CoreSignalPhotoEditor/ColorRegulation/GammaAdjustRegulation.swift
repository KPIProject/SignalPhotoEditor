//
//  GammaAdjustRegulation.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 02.12.2020.
//

import UIKit

/**
 Adjusts midtone brightness.
 */
struct GammaAdjustRegulation: Regulation {
    
    var filterName: String = "Gamma"
    
    var value: Float = 0
    var minimumValue: Float = 0
    var maximumValue: Float = 6
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.gammaAdjust()
        currentFilter.inputImage = image
        currentFilter.power = value
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
    }
}
