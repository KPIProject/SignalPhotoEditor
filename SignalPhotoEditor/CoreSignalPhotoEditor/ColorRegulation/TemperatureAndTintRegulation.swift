//
//  TemperatureAndTintRegulation.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 02.12.2020.
//

import UIKit

/**
 CITemperatureAndTint has three input parameters: Image, Neutral and TargetNeutral. Neutral and TargetNeutral are of 2D CIVector type, and in both of them, note that the first dimension refers to Temperature and the second dimension refers to Tint. What the CITemperatureAndTint filter basically does is computing a matrix that adapts RGB values from the source white point defined by Neutral (srcTemperature, srcTint) to the target white point defined by TargetNeutral (dstTemperature, dstTint), and then applying this matrix on the input image (using the CIColorMatrix filter). If Neutral and TargetNeutral are of the same values, then the image will not change after applying this filter.
 */
struct TemperatureAndTintRegulation: Regulation {
    
    var filterName: String? = "Color Controls"
    
//    var inputNeutral: Float = 1.0
//
//    var inputTargetNeutral: Float = 1.0
    
    var inputTemperatute: Float = 0.0
    
    var inputTint: Float = 0.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.temperatureAndTint()
        currentFilter.inputImage = image
        currentFilter.targetNeutral = CIVector(x: CGFloat(6500 + inputTemperatute), y: CGFloat(inputTint))
       

        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
    }
}
