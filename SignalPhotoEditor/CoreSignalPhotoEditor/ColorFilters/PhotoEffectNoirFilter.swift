//
//  PhotoEffectNoirFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct PhotoEffectNoirFilter: Filter {
    
    var filterName: String? = "PhotoEffectNoir"
    var intensity: Float? = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.photoEffectNoir()
        currentFilter.inputImage = image
        applyIntensity(image: &image, filter: currentFilter)

    }
}

