//
//  ContrastRegulation.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 07.12.2020.
//

import UIKit

struct ContrastRegulation: Regulation {
    
    var filterName: String = "Contrast"
    
    var value: Float = 0.0
    var minimumValue: Float = -0.18
    var maximumValue: Float = 0.18
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.colorControls()
        currentFilter.inputImage = image
        currentFilter.contrast = 1 + value
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else {
            return
        }
        
        image = outputImage
    }
}
