//
//  VibranceRegulation.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 02.12.2020.
//

import UIKit

/**
 Adjusts the saturation of an image while keeping pleasing skin tones.
 */
struct VibranceRegulation: Filter {
    var intensity: Float?
    
    var filterName: String? = "Color Controls"
    
    var inputAmount: Float = 0.0
        
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.vibrance()
        currentFilter.inputImage = image
        currentFilter.amount = inputAmount
       

        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
    }
}

