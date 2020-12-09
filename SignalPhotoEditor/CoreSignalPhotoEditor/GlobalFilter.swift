//
//  GlobalFilter.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 03.12.2020.
//

import UIKit

protocol GlobalFilter {
    
    var filterName: String { get }
    
    var value: Float { get set }
    var minimumValue: Float { get }
    var maximumValue: Float { get }
    
    func applyFilter(image: inout CIImage)
}

protocol Regulation: GlobalFilter { }

protocol Filter: GlobalFilter { }

extension Filter {
    
    var minimumValue: Float {
        return 0.0
    }
    
    var maximumValue: Float {
        return 1.0
    }
    
    func applyIntensity(image: inout CIImage, filter: CIFilter) {
        
        let background = image
        let foreground = filter.outputImage!.applyingFilter(
            "CIColorMatrix", parameters: [
                "inputRVector": CIVector(x: 1, y: 0, z: 0, w: CGFloat(0)),
                "inputGVector": CIVector(x: 0, y: 1, z: 0, w: CGFloat(0)),
                "inputBVector": CIVector(x: 0, y: 0, z: 1, w: CGFloat(0)),
                "inputAVector": CIVector(x: 0, y: 0, z: 0, w: CGFloat(value)),
                "inputBiasVector": CIVector(x: 0, y: 0, z: 0, w: 0),
            ])
        
        let composition = CIFilter(
            name: "CISourceOverCompositing",
            parameters: [
                kCIInputImageKey : foreground,
                kCIInputBackgroundImageKey : background
            ])!
        
        image = composition.outputImage!
    }
}
