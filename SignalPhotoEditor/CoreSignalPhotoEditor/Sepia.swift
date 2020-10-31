//
//  Sepia.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 31.10.2020.
//

import UIKit

struct Sepia: Filter {
    
    var filterName: String = "Sepia"
    
    var filterEffectValue: Any?
    
    var filterEffectValueName: String?
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.sepiaTone()
        currentFilter.inputImage = image
        currentFilter.intensity = 1
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
        
    }
    
}
