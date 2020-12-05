//
//  WhitePointAdjustRegulation.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 02.12.2020.
//

import UIKit

/**
 Adjusts the saturation of an image while keeping pleasing skin tones.
 */
//struct WhitePointAdjustRegulation: Filter {
//    var value: Float?
//    
//    var filterName: String = "White Point Adjust"
//    
//    var inputColor: CIColor = .white
//        
//    func applyFilter(image: inout CIImage) {
//        
//        let currentFilter = CIFilter.whitePointAdjust()
//        currentFilter.inputImage = image
//        currentFilter.color = inputColor
//       
//        applyIntensity(image: &image, filter: currentFilter)
//        
//        // get a CIImage from our filter or exit if that fails
////        guard let outputImage = currentFilter.outputImage else { return }
////        
////        image = outputImage
//    }
//}
