//
//  PhotoEffectProcessFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct PhotoEffectProcessFilter: Filter {
    
    var filterName: String? = "Process"
    var intensity: Float? = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.photoEffectProcess()
        currentFilter.inputImage = image
        applyIntensity(image: &image, filter: currentFilter)
        
    }
}
