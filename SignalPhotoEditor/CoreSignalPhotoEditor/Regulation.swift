//
//  Regulation.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 02.12.2020.
//

import UIKit
//
//protocol Regulation {
//    var filterName: String? { get }
//    func applyFilter(image: inout CIImage)
//}


enum Regulations {
    case saturation(value: Float)
    case brightness(value: Float)
    case contrast(value: Float)
    case exposure(value: Float)
    case gammaAdjust(value: Float)
    case hueAdjust(value: Float)
    case temperature(value: Float)
    case tint(value: Float)
    case vibrance(value: Float)
    case whitePointAdjust(color: CIColor, intensity: Float)
    case vignette(radius: Float, intensity: Float)
    
    func getFilter() -> Filter {
        switch self {
        case let .saturation(value):
            return ColorControlsRegulation(inputSaturation: value)
        case let .brightness(value):
            return ColorControlsRegulation(inputBrightness: value)
        case let .contrast(value):
            return ColorControlsRegulation(inputContrast: value)
        case let .exposure(value):
            return ExposureAdjustRegulation(inputEV: value)
        case let .gammaAdjust(value):
            return GammaAdjustRegulation(inputPower: value)
        case let .hueAdjust(value):
            return HueAdjustRegulation(inputAngle: value)
        case let .temperature(value):
            return TemperatureAndTintRegulation(inputTemperatute: value)
        case let .tint(value):
            return TemperatureAndTintRegulation(inputTint: value)
        case let .vibrance(value):
            return VibranceRegulation(inputAmount: value)
        case let .whitePointAdjust(color, intensity):
            return WhitePointAdjustRegulation(intensity: intensity, inputColor: color)
        case let .vignette(radius, intensity):
            return VignetteFilter(intensity: intensity, radius: radius)
        }
    }
}
