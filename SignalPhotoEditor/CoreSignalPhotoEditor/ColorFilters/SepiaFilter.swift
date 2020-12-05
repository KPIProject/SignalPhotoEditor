//
//  SepiaFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 31.10.2020.
//

import UIKit

struct SepiaFilter: Filter {
    
    var filterName: String = "Sepia"
    
    var value: Float = 1
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.sepiaTone()
        currentFilter.inputImage = image
        currentFilter.intensity = value ?? 1
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
    }
}
