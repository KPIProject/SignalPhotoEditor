//
//  CrossPolynomialFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct CrossPolynomialFilter: Filter {
    
    var filterName: String? = "CrossPolynomialFilter"
    
//    var intensity: Float = 0.0
    
//    var radius: Float = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.colorCrossPolynomial()
        currentFilter.inputImage = image
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
        
    }
    
}
