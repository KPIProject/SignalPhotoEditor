//
//  PhotoEffectTonalFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct PhotoEffectTonalFilter: Filter {
    
    var filterName: String = "Tonal"
    var value: Float = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.photoEffectTonal()
        currentFilter.inputImage = image
        applyIntensity(image: &image, filter: currentFilter)
    }
}
