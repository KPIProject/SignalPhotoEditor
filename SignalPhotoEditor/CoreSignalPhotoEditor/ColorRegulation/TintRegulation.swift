//
//  TintRegulation.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 07.12.2020.
//

import UIKit

struct TintRegulation: Regulation {
    
    var filterName: String = "Tint"
    
    var value: Float = 0.0
    var minimumValue: Float = -100
    var maximumValue: Float = 100
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.temperatureAndTint()
        currentFilter.inputImage = image
        currentFilter.targetNeutral = CIVector(x: 6500, y: CGFloat(value))
        
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else {
            return
        }
        
        image = outputImage
    }
}
