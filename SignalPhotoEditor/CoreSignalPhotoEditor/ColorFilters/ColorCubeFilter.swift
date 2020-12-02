//
//  CrossPolynomialFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct ColorCubeFilter: Filter {
    
    var filterName: String? = "ColorCube"
    
    var cubeData: Data?
    var dimension: Float = 64
    var lutImage: UIImage
    
    var intensity: Float? = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        // TODO: - Other LUTs adding
        let data = ColorCube.cubeData(lutImage: lutImage, dimension: 64, colorSpace: CGColorSpaceCreateDeviceRGB())
                
        let currentFilter = CIFilter.colorCube()
        currentFilter.cubeDimension = dimension
        guard let cubedata = data else { return }
        currentFilter.cubeData = cubedata
        currentFilter.inputImage = image
        
        applyIntensity(image: &image, filter: currentFilter)
        
    }
    
}
