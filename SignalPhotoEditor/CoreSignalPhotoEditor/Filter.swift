//
//  Filter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 31.10.2020.
//

import UIKit


protocol Filter {
    var filterName: String? { get }
    func applyFilter(image: inout CIImage)
}


enum Filters {
    case sepia(intensity: Float)
    case vignette(intensity: Float, radius: Float)
    case vignetteEffect(intensity: Float, radius: Float, center: (x: CGFloat, y: CGFloat))
    case colorInvert
    case colorMap(inputGradient: UIImage)
    case colorMonochrome(intensity: Float, inputColor: CIColor)
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
    
    func getFilter() -> Filter {
        switch self {
        case let .sepia(intensity: intensity):
            return SepiaFilter(intensity: intensity)
        case let .vignette(intensity: intensity, radius: radius):
            return VignetteFilter(intensity: intensity, radius: radius)
        case let .vignetteEffect(intensity: intensity, radius:  radius, center: (x: x, y: y)):
            return VignetteEffectFilter(intensity: intensity, radius: radius, center: (x: x, y: y))
        case .colorInvert:
            return ColorInvertFilter()
        case let .colorMap(inputGradient: image):
            return ColorMapFilter(inputGradient: image)
        case let .colorMonochrome(intensity: intensity, inputColor: color):
            return ColorMonochromeFilter(inputColor: color, intensity: intensity)
        case let .colorPosterize(level: level):
            return ColorPosterizeFilter(level: level)
        case let .falseColor(color0: color0, color1: color1):
            return FalseColorFilter(color0: color0, color1: color1)
        case .maximumComponent:
            return MaximumComponentFilter()
        case .minimumComponent:
            return MinimumComponentFilter()
        case .photoEffectChrome:
            return PhotoEffectChromeFilter()
        case .photoEffectFade:
            return PhotoEffectFadeFilter()
        case .photoEffectInstant:
            return PhotoEffectInstantFilter()
        case .photoEffectMono:
            return PhotoEffectMonoFilter()
        case .photoEffectNoir:
            return PhotoEffectNoirFilter()
        case .photoEffectProcess:
            return PhotoEffectProcessFilter()
        case .photoEffectTonal:
            return PhotoEffectTonalFilter()
        case .photoEffectTransfer:
            return PhotoEffectTransferFilter()
        }
    }
}
