//
//  PhotoEffectTransferFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct PhotoEffectTransferFilter: Filter {
    
    var filterName: String? = "PhotoEffectTransfer"
    var intensity: Float = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.photoEffectTransfer()
        currentFilter.inputImage = image
        applyIntensity(image: &image, filter: currentFilter)
 
    }
}
