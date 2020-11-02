//
//  MinimumComponentFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct MinimumComponentFilter: Filter {
    
    var filterName: String? = "MinimumComponent"
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.minimumComponent()
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
        
    }
}
