//
//  PhotoEffectProcessFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct PhotoEffectProcessFilter: Filter {
    
    var filterName: String? = "PhotoEffectProcess"
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.photoEffectProcess()
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
        
    }
}
