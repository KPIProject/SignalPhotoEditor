//
//  TemperatureRegulation.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 07.12.2020.
//

import UIKit

struct TemperatureRegulation: Regulation {
    
    var filterName: String = "Temperature"
    
    var value: Float = 0.0
    var minimumValue: Float = 8000
    var maximumValue: Float = -4000
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.temperatureAndTint()
        currentFilter.inputImage = image
        currentFilter.targetNeutral = CIVector(x: CGFloat(6500 + value), y: 0)
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else {
            return
        }
        
        image = outputImage
    }
}
