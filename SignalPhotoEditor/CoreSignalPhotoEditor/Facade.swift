//
//  Interface.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 31.10.2020.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class Facade {
    
    let image: UIImage
    let filteres: [Filter]
    
    init(image: UIImage, filteres: [Filter]) {
        self.image = image
        self.filteres = filteres
    }
    
    func applyFilters() -> UIImage {
        var newImage = UIImage()
        
        guard var ciImage = CIImage(image: image) else { return image }
        
        let context = CIContext()
        
        for filter in filteres {
             filter.applyFilter(image: &ciImage)
        }
        
        // attempt to get a CGImage from our CIImage
        if let newCGImage = context.createCGImage(ciImage, from: ciImage.extent) {
            // convert that to a UIImage
            newImage = UIImage(cgImage: newCGImage)
        }
        // apply all filters
        return newImage
    }
}
