//
//  ExposureAdjustRegulation.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 02.12.2020.
//

import UIKit

struct ExposureAdjustRegulation: Regulation {
    
    var filterName: String = "Exposure"
    
    var value: Float = 0
    var minimumValue: Float = -2
    var maximumValue: Float = 2
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.exposureAdjust()
        currentFilter.inputImage = image
        currentFilter.ev = value
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
    }
}
