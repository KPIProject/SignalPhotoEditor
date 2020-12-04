//
//  CrossPolynomialFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct ColorCubeFilter: Filter {
    
    var filterName: String = "ColorCube"
    
    var cubeData: Data?
    var dimension: Float = 64
    var lutImage: UIImage
    
    var intensity: Float? = 1.0
    
    func applyFilter(image: inout CIImage) {
        
        // TODO: - Other LUTs adding
        let data = ColorCube.cubeData(lutImage: lutImage,
                                      dimension: Int(dimension),
                                      colorSpace: CGColorSpace.init(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB())
        
        let filter = CIFilter(
            name: "CIColorCubeWithColorSpace",
            parameters: [
                "inputCubeDimension" : dimension,
                "inputCubeData" : data ?? Data(),
                "inputColorSpace" : CGColorSpace.init(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB(),
            ]
        )
    
        filter!.setValue(image, forKeyPath: kCIInputImageKey)
        applyIntensity(image: &image, filter: filter!)
        
    }
    
    func applyIntensity(image: inout CIImage, filter: CIFilter) {
        
        if let colorSpace = image.colorSpace {
            filter.setValue(colorSpace, forKeyPath: "inputColorSpace")
        }
        
        let background = image
        let foreground = filter.outputImage!.applyingFilter(
            "CIColorMatrix", parameters: [
                "inputRVector": CIVector(x: 1, y: 0, z: 0, w: CGFloat(0)),
                "inputGVector": CIVector(x: 0, y: 1, z: 0, w: CGFloat(0)),
                "inputBVector": CIVector(x: 0, y: 0, z: 1, w: CGFloat(0)),
                "inputAVector": CIVector(x: 0, y: 0, z: 0, w: CGFloat(unwrappedIntensity)),
                "inputBiasVector": CIVector(x: 0, y: 0, z: 0, w: 0),
            ])
        
        let composition = CIFilter(
            name: "CISourceOverCompositing",
            parameters: [
                kCIInputImageKey : foreground,
                kCIInputBackgroundImageKey : background
            ])!
        
        image = composition.outputImage!
    }
    
}
