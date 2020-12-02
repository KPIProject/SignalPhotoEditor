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
struct GammaAdjustRegulation: Filter {
    var intensity: Float?
    
    var filterName: String? = "Gamma Adjust"
    
    var inputPower: Float = 0.75

    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.gammaAdjust()
        currentFilter.inputImage = image
        currentFilter.power = inputPower

        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
    }
}
