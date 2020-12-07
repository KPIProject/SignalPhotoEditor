//
//  PhotoEffectFadeFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct PhotoEffectFadeFilter: Filter {
    
    var filterName: String = "Fade"
    var value: Float = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.photoEffectFade()
        currentFilter.inputImage = image
        
        applyIntensity(image: &image, filter: currentFilter)
    }
}
