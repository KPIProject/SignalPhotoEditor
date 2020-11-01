//
//  PhotoEffectTonalFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct PhotoEffectTonalFilter: Filter {
    
    var filterName: String? = "PhotoEffectTonal"
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.photoEffectTonal()
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
        
    }
}
