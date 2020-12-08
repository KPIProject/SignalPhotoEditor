//
//  Filter.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 31.10.2020.
//

import UIKit


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
//    case colorMap(inputGradient: UIImage)
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
        Filters.colorCube(name: "Autumn", lutImage: UIImage(named: "Autumn") ?? UIImage()).getFilter(),
        Filters.colorCube(name: "Cake", lutImage: UIImage(named: "Cake") ?? UIImage()).getFilter(),
        Filters.colorCube(name: "Coffee", lutImage: UIImage(named: "Coffee") ?? UIImage()).getFilter(),
        Filters.colorCube(name: "Field", lutImage: UIImage(named: "Field") ?? UIImage()).getFilter(),
        Filters.colorCube(name: "Flamingo", lutImage: UIImage(named: "Flamingo") ?? UIImage()).getFilter(),
        Filters.colorCube(name: "Jungle", lutImage: UIImage(named: "Jungle") ?? UIImage()).getFilter(),
    ]
    
    func getFilter(intensity: Float = 1) -> Filter {
        switch self {
        case .sepia:
            return SepiaFilter(value: intensity)
        //        case let .vignetteEffect(radius:  radius, center: (x: x, y: y)):
        //            return VignetteEffectFilter(intensity: intensity, radius: radius, center: (x: x, y: y))
        case .colorInvert:
            return ColorInvertFilter()
//        case let .colorMap(inputGradient: image):
//            return ColorMapFilter(inputGradient: image)
        case let .colorMonochrome(inputColor: color):
            return ColorMonochromeFilter(value: intensity, inputColor: color)
        case let .colorPosterize(level: level):
            return ColorPosterizeFilter(level: level)
        case let .falseColor(color0: color0, color1: color1):
            return FalseColorFilter(value: intensity, color0: color0, color1: color1)
        case .maximumComponent:
            return MaximumComponentFilter(value: intensity)
        case .minimumComponent:
            return MinimumComponentFilter(value: intensity)
        case .photoEffectChrome:
            return PhotoEffectChromeFilter(value: intensity)
        case .photoEffectFade:
            return PhotoEffectFadeFilter(value: intensity)
        case .photoEffectInstant:
            return PhotoEffectInstantFilter(value: intensity)
        case .photoEffectMono:
            return PhotoEffectMonoFilter(value: intensity)
        case .photoEffectNoir:
            return PhotoEffectNoirFilter(value: intensity)
        case .photoEffectProcess:
            return PhotoEffectProcessFilter(value: intensity)
        case .photoEffectTonal:
            return PhotoEffectTonalFilter(value: intensity)
        case .photoEffectTransfer:
            return PhotoEffectTransferFilter(value: intensity)
        case let .colorCube(name, lutImage):
            return ColorCubeFilter(filterName: name, value: intensity, lutImage: lutImage)
        }
    }

}
