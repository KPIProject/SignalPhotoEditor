//
//  Regulation.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 02.12.2020.
//

import UIKit

enum Regulations {
    case brightness(value: Float = 0)
    case saturation(value: Float = 0)
    case contrast(value: Float = 0)
    case exposure(value: Float = 0)
    case gammaAdjust(value: Float = 0)
    case hueAdjust(value: Float = 0)
    case temperature(value: Float = 0)
    case tint(value: Float = 0)
    case vibrance(value: Float = 0)
    //    case whitePointAdjust(color: CIColor, intensity: Float)
    case vignette(value: Float = 0)
    
    static var filterCollectionModels: [FilterModel] = [
        // inputBrightness [-1...1]
        FilterModel(image: UIImage(named: "Brightness")!,
                    filter: Regulations.brightness().getFilter()),
        // inputSaturation [0...1]
        FilterModel(image: UIImage(named: "Saturation")!,
                    filter: Regulations.saturation().getFilter()),
        // inputContrast [0...1]
        FilterModel(image: UIImage(named: "Contrast")!,
                    filter: Regulations.contrast().getFilter()),
        // inputEV[-2...2]
        FilterModel(image: UIImage(named: "Exposure")!,
                    filter: Regulations.exposure().getFilter()),
        // inputPower[0...6]
        FilterModel(image: UIImage(named: "Gamma")!,
                    filter: Regulations.gammaAdjust().getFilter()),
        // inputAngle[-180...180]
        FilterModel(image: UIImage(named: "Hue")!,
                    filter: Regulations.hueAdjust().getFilter()),
        // inputTemperatute[-4000..0.+9000]
        FilterModel(image: UIImage(named: "Temperature")!,
                    filter: Regulations.temperature().getFilter()),
        // inputTint[-100...100]
        FilterModel(image: UIImage(named: "Tint")!,
                    filter: Regulations.tint().getFilter()),
        // inputAmount [0...1]
        FilterModel(image: UIImage(named: "Vibrance")!,
                    filter: Regulations.vibrance().getFilter()),
        // intensity [-1...1], inputColor [CIColor]
//        FilterModel(image: UIImage(named: "WhitePoint")!,
//                    filter: Regulations.whitePointAdjust(color: .yellow, intensity: 0.5).getFilter()),
        // intensity [0...1], radius[1...100 ? ]
        FilterModel(image: UIImage(named: "Vignette")!,
                    filter: Regulations.vignette().getFilter())
    ]
    
    //    static var allCases: [FilterModel] = [
    //        FilterModel(image: UIImage(named: "Brightness")!,
    //                    displayName: "Brightness",
    //                    filtersFirst: (positiveFilter: Regulation.brightness(value: BrightnessRegulation.minValue), negativeFilter: Filter?))
    //
    //    ]
    
    
    func getFilter() -> Regulation {
        
        
        switch self {
        case let .saturation(value):
            return SaturationRegulation(value: value)
        case let .brightness(value):
            return BrightnessRegulation(value: value)
        case let .contrast(value):
            return ContrastRegulation(value: value)
        case let .exposure(value):
            return ExposureAdjustRegulation(value: value)
        case let .gammaAdjust(value):
            return GammaAdjustRegulation(value: value)
        case let .hueAdjust(value):
            return HueAdjustRegulation(value: value)
        case let .temperature(value):
            return TemperatureRegulation(value: value)
        case let .tint(value):
            return TintRegulation(value: value)
        case let .vibrance(value):
            return VibranceRegulation(value: value)
        //        case let .whitePointAdjust(color, intensity):
        //            return WhitePointAdjustRegulation(value: intensity, inputColor: color)
        case let .vignette(value):
            return VignetteFilter(value: value)
        }
    }
}
