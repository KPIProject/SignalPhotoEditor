//
//  ColorInvertFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct ColorInvertFilter: Filter {
    
    var filterName: String? = "Invert"
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.colorInvert()
        currentFilter.inputImage = image
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
        
    }
    
}

