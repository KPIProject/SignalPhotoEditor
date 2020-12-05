//
//  ExposureAdjustRegulation.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 02.12.2020.
//

import UIKit

struct ExposureAdjustRegulation: Filter {
    var intensity: Float?
    
    var filterName: String = "Exposure"
    
    var inputEV: Float = 0.5

    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.exposureAdjust()
        currentFilter.inputImage = image
        currentFilter.ev = inputEV

        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
    }
}
