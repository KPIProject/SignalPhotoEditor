//
//  PhotoEffectMonoFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct PhotoEffectMonoFilter: Filter {
    
    var filterName: String = "Mono"
    var value: Float = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.photoEffectMono()
        currentFilter.inputImage = image
        
        applyIntensity(image: &image, filter: currentFilter)
    }
}
