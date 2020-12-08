//
//  SaturationRegulation.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 07.12.2020.
//

import UIKit

struct SaturationRegulation: Regulation {
    
    var filterName: String = "Saturation"
    
    var value: Float = 0.0
    var minimumValue: Float = -1.0
    var maximumValue: Float = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.colorControls()
        currentFilter.inputImage = image
        currentFilter.saturation = 1 + value
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
    }
}
