//
//  PhotoEffectFadeFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct PhotoEffectFadeFilter: Filter {
    
    var filterName: String? = "PhotoEffectFade"
    
    func applyFilter(image: inout CIImage) {
        
        let currentFilter = CIFilter.photoEffectFade()
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        
        image = outputImage
        
    }
}
