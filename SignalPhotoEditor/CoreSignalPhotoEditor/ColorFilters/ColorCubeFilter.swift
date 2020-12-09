//
//  CrossPolynomialFilter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 01.11.2020.
//

import UIKit

struct ColorCubeFilter: Filter {
    
    var filterName: String = "ColorCube"
    var value: Float = 1.0
    
    var cubeData: Data?
    var dimension: Float = 64
    var lutImage: UIImage
    
    func applyFilter(image: inout CIImage) {
        
        let colorSpace = CGColorSpace.init(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB()
        let data = ColorCube.cubeData(lutImage: lutImage,
                                      dimension: Int(dimension),
                                      colorSpace: colorSpace)
        
        let filter = CIFilter(
            name: "CIColorCubeWithColorSpace",
            parameters: [
                "inputCubeDimension" : dimension,
                "inputCubeData" : data ?? Data(),
                "inputColorSpace" : colorSpace,
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
                "inputAVector": CIVector(x: 0, y: 0, z: 0, w: CGFloat(value)),
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
