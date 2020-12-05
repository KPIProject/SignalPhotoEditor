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
struct HueAdjustRegulation: Filter {
    var intensity: Float?
    
    var filterName: String = "Hue"
    
    var inputAngle: Float = 0.0

    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.hueAdjust()
        currentFilter.inputImage = image
        currentFilter.angle = inputAngle

        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
    }
}
