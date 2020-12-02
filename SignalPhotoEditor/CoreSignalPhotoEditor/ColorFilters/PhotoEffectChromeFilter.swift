//
//  PhotoEffectChromeFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct PhotoEffectChromeFilter: Filter {
    
    var filterName: String? = "PhotoEffectChrome"
    var intensity: Float = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.photoEffectChrome()
        currentFilter.inputImage = image
        applyIntensity(image: &image, filter: currentFilter)
   
    }
}
