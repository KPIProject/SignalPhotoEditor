//
//  VignetteEffectFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct VignetteEffectFilter: Filter {
    
    var filterName: String = "VignetteEffect"
    
    var intensity: Float?
    
    var radius: Float = 1.0
    
    var center: (x: CGFloat, y: CGFloat) = (150, 150)
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.vignetteEffect()
        currentFilter.inputImage = image
        currentFilter.intensity = intensity ?? 0.0
        currentFilter.radius = radius
        
        let vector = CGPoint(x: center.x, y: center.y)
        currentFilter.center = vector
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
        
    }
    
}
