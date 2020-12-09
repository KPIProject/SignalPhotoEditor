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
struct VibranceRegulation: Regulation {
    
    var filterName: String = "Vibrance"
    
    var value: Float = 0.0
    var minimumValue: Float = 0.0
    var maximumValue: Float = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.vibrance()
        currentFilter.inputImage = image
        currentFilter.amount = value
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else {
            return
        }
        
        image = outputImage
    }
}

