//
//  ColorControlsRegulation.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 02.12.2020.
//

import UIKit

/**
 Saturation + Brightness + Contrast
 */
//struct ColorControlsRegulation: Filter {
//
//    var intensity: Float?
//
//    var filterName: String = "Color Controls"
//
//    var inputSaturation: Float = 1.0
//
//    var inputBrightness: Float = 1.0
//
//    var inputContrast: Float = 1.0
//
//    func applyFilter(image: inout CIImage) {
//
//        let currentFilter = CIFilter.colorControls()
//        currentFilter.inputImage = image
//        currentFilter.saturation = inputSaturation
//        currentFilter.brightness = inputBrightness
//        currentFilter.contrast = inputContrast
//
//        // get a CIImage from our filter or exit if that fails
//        guard let outputImage = currentFilter.outputImage else { return }
//
//        image = outputImage
//    }
//}

struct SaturationRegulation: Regulation {
    
    var filterName: String = "Saturation"
    
    var value: Float = 0.0
    var minimumValue: Float = -1.0
    var maximumValue: Float = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.colorControls()
        currentFilter.inputImage = image
        currentFilter.saturation = value
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
    }
}

struct BrightnessRegulation: Regulation {
    
    var filterName: String = "Brightness"
    
    var value: Float = 0.0
    var minimumValue: Float = 0.0
    var maximumValue: Float = 1.0
    
    var inputBrightness: Float = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.colorControls()
        currentFilter.inputImage = image
        currentFilter.brightness = inputBrightness
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
    }
}

struct ContrastRegulation: Regulation {
    
    var filterName: String = "Contrast"
    
    var value: Float = 0.0
    var minimumValue: Float = -1.0
    var maximumValue: Float = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.colorControls()
        currentFilter.inputImage = image
        currentFilter.contrast = value
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
    }
}
