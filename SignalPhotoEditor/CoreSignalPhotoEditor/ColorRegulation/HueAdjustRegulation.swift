//
//  HueAdjustRegulation.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 02.12.2020.
//

import UIKit

/**
 Changes the overall hue, or tint, of the source pixels.
 This filter essentially rotates the color cube around the neutral axis.
 */
struct HueAdjustRegulation: Regulation {
    
    var filterName: String = "Hue"
    
    var value: Float = 0.0
    var minimumValue: Float = -Float.pi
    var maximumValue: Float = Float.pi
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.hueAdjust()
        currentFilter.inputImage = image
        currentFilter.angle = value
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else {
            return
        }
        
        image = outputImage
    }
}
