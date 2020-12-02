//
//  Filter.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 31.10.2020.
//

import UIKit


protocol Filter {
    var filterName: String { get }
    var intensity: Float? { get }
    func applyFilter(image: inout CIImage)
}



extension Filter {
    
    var unwrappedIntensity: Float {
        return intensity ?? 1
    }
    
    func applyIntensity(image: inout CIImage, filter: CIFilter) {
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

enum Filters {
    
    case sepia
    //    case vignetteEffect(radius: Float, center: (x: CGFloat, y: CGFloat))
    case colorInvert
    case colorMonochrome(inputColor: CIColor)
    case colorPosterize(level: Float = 6)
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
    // With input Image
    case colorMap(inputGradient: UIImage)
    case colorCube(name: String, lutImage: UIImage)
    
    static var allCases: [Filter] = [
        Filters.sepia.getFilter(),
        Filters.photoEffectChrome.getFilter(),
        Filters.photoEffectFade.getFilter(),
        Filters.photoEffectMono.getFilter(),
        Filters.maximumComponent.getFilter(),
        Filters.minimumComponent.getFilter(),
        Filters.photoEffectInstant.getFilter(),
        Filters.photoEffectNoir.getFilter(),
        Filters.photoEffectProcess.getFilter(),
        Filters.photoEffectTonal.getFilter(),
        Filters.photoEffectTransfer.getFilter(),
        Filters.colorInvert.getFilter(),
        Filters.colorPosterize().getFilter(),
        Filters.colorCube(name: "Persian", lutImage: UIImage(named: "Persian") ?? UIImage()).getFilter(),
    ]
    
    func getFilter(intensity: Float = 1) -> Filter {
        switch self {
        case .sepia:
            return SepiaFilter(intensity: intensity)
        //        case let .vignetteEffect(radius:  radius, center: (x: x, y: y)):
        //            return VignetteEffectFilter(intensity: intensity, radius: radius, center: (x: x, y: y))
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
        case let .colorCube(name, lutImage):
            return ColorCubeFilter(filterName: name, lutImage: lutImage, intensity: intensity)
        }
    }
}
