//
//  BrightnessRegulation.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 07.12.2020.
//

import UIKit

struct BrightnessRegulation: Regulation {
    
    var filterName: String = "Brightness"
    
    var value: Float = 0.0
    var minimumValue: Float = -0.2
    var maximumValue: Float = 0.2
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.colorControls()
        currentFilter.inputImage = image
        currentFilter.brightness = value
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else {
            return
        }
        
        image = outputImage
    }
}
