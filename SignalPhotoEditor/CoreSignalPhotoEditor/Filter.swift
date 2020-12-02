//
//  Filter.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 31.10.2020.
//

import UIKit


protocol Filter {
    var filterName: String? { get }
    var intensity: Float? { get }
    func applyFilter(image: inout CIImage)
}



extension Filter {
    func applyIntensity(image: inout CIImage, filter: CIFilter) {
        let background = image
        let foreground = filter.outputImage!.applyingFilter(
            "CIColorMatrix", parameters: [
                "inputRVector": CIVector(x: 1, y: 0, z: 0, w: CGFloat(0)),
                "inputGVector": CIVector(x: 0, y: 1, z: 0, w: CGFloat(0)),
                "inputBVector": CIVector(x: 0, y: 0, z: 1, w: CGFloat(0)),
                "inputAVector": CIVector(x: 0, y: 0, z: 0, w: CGFloat(intensity ?? 1)),
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

enum Filters {
    case sepia
    case vignette(radius: Float)
    case vignetteEffect(radius: Float, center: (x: CGFloat, y: CGFloat))
    case colorInvert
    case colorMap(inputGradient: UIImage)
    case colorMonochrome(inputColor: CIColor)
    case colorPosterize(level: Float)
    case falseColor(color0: CIColor, color1: CIColor)
    case maximumComponent
    case minimumComponent
    case photoEffectChrome
    case photoEffectFade
    case photoEffectInstant
    case photoEffectMono
    case photoEffectNoir
    case photoEffectProcess
    case photoEffectTonal
    case photoEffectTransfer
    case colorCube(lutImage: UIImage)
    
    func getFilter(intensity: Float) -> Filter {
        switch self {
        case .sepia:
            return SepiaFilter(intensity: intensity)
        case let .vignette(radius: radius):
            return VignetteFilter(intensity: intensity, radius: radius)
        case let .vignetteEffect(radius:  radius, center: (x: x, y: y)):
            return VignetteEffectFilter(intensity: intensity, radius: radius, center: (x: x, y: y))
        case .colorInvert:
            return ColorInvertFilter()
        case let .colorMap(inputGradient: image):
            return ColorMapFilter(inputGradient: image)
        case let .colorMonochrome(inputColor: color):
            return ColorMonochromeFilter(intensity: intensity, inputColor: color)
        case let .colorPosterize(level: level):
            return ColorPosterizeFilter(level: level)
        case let .falseColor(color0: color0, color1: color1):
            return FalseColorFilter(intensity: intensity, color0: color0, color1: color1)
        case .maximumComponent:
            return MaximumComponentFilter(intensity: intensity)
        case .minimumComponent:
            return MinimumComponentFilter(intensity: intensity)
        case .photoEffectChrome:
            return PhotoEffectChromeFilter(intensity: intensity)
        case .photoEffectFade:
            return PhotoEffectFadeFilter(intensity: intensity)
        case .photoEffectInstant:
            return PhotoEffectInstantFilter(intensity: intensity)
        case .photoEffectMono:
            return PhotoEffectMonoFilter(intensity: intensity)
        case .photoEffectNoir:
            return PhotoEffectNoirFilter(intensity: intensity)
        case .photoEffectProcess:
            return PhotoEffectProcessFilter(intensity: intensity)
        case .photoEffectTonal:
            return PhotoEffectTonalFilter(intensity: intensity)
        case .photoEffectTransfer:
            return PhotoEffectTransferFilter(intensity: intensity)
        case let .colorCube(lutImage):
            return ColorCubeFilter(lutImage: lutImage, intensity: intensity)
        }
    }
}
