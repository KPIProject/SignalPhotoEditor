//
//  Regulation.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 02.12.2020.
//

import UIKit

enum Regulations {
    case brightness(value: Float)
    case saturation(value: Float)
    case contrast(value: Float)
    case exposure(value: Float)
    case gammaAdjust(value: Float)
    case hueAdjust(value: Float)
    case temperature(value: Float)
    case tint(value: Float)
    case vibrance(value: Float)
    case whitePointAdjust(color: CIColor, intensity: Float)
    case vignette(radius: Float, intensity: Float)
    
    static var filterCollectionModels: [FilterCollectionModel] = [
        // inputBrightness [-1...1]
        FilterCollectionModel(image: UIImage(named: "Brightness")!,
                              filter: Regulations.brightness(value: 0).getFilter(),
                              firstSliderModel: SliderModel(name: "",
                                                            sliderNumber: 1,
                                                            defaultValue: 0,
                                                            minimumValue: -100,
                                                            maximumValue: 100)),
        // inputSaturation [0...1]
        FilterCollectionModel(image: UIImage(named: "Saturation")!,
                              filter: Regulations.saturation(value: -20).getFilter(),
                              firstSliderModel: SliderModel(name: "",
                                                            sliderNumber: 1,
                                                            defaultValue: 0,
                                                            minimumValue: 0,
                                                            maximumValue: 100)),
        // inputContrast [0...1]
        FilterCollectionModel(image: UIImage(named: "Contrast")!,
                              filter: Regulations.contrast(value: 3).getFilter(),
                              firstSliderModel: SliderModel(name: "",
                                                            sliderNumber: 1,
                                                            defaultValue: 0,
                                                            minimumValue: 0,
                                                            maximumValue: 100)),
        // inputEV[-2...2]
        FilterCollectionModel(image: UIImage(named: "Exposure")!,
                              filter: Regulations.exposure(value: 0.5).getFilter(),
                              firstSliderModel: SliderModel(name: "EV",
                                                            sliderNumber: 1,
                                                            defaultValue: 0,
                                                            minimumValue: -200,
                                                            maximumValue: 200)),
        // inputPower[0...6]
        FilterCollectionModel(image: UIImage(named: "Gamma")!,
                              filter: Regulations.gammaAdjust(value: 0.1).getFilter(),
                              firstSliderModel: SliderModel(name: "",
                                                            sliderNumber: 1,
                                                            defaultValue: 0,
                                                            minimumValue: 0,
                                                            maximumValue: 60)),
        // inputAngle[-180...180]
        FilterCollectionModel(image: UIImage(named: "Hue")!,
                              filter: Regulations.hueAdjust(value: Float(260 * Double.pi / 180)).getFilter(),
                              firstSliderModel: SliderModel(name: "",
                                                            sliderNumber: 1,
                                                            defaultValue: 0,
                                                            minimumValue: -180,
                                                            maximumValue: 180)),
        // inputTemperatute[-4000..0.+9000]
        FilterCollectionModel(image: UIImage(named: "Temperature")!,
                              filter: Regulations.temperature(value: -4000).getFilter(),
                              firstSliderModel: SliderModel(name: "",
                                                            sliderNumber: 1,
                                                            defaultValue: 0,
                                                            minimumValue: -4000,
                                                            maximumValue: 9000)),
        // inputTint[-100...100]
        FilterCollectionModel(image: UIImage(named: "Tint")!,
                              filter: Regulations.tint(value: 100).getFilter(),
                              firstSliderModel: SliderModel(name: "",
                                                            sliderNumber: 1,
                                                            defaultValue: 0,
                                                            minimumValue: -100,
                                                            maximumValue: 100)),
        // inputAmount [0...1]
        FilterCollectionModel(image: UIImage(named: "Vibrance")!,
                              filter: Regulations.vibrance(value: 1).getFilter(),
                              firstSliderModel: SliderModel(name: "",
                                                            sliderNumber: 1,
                                                            defaultValue: 0,
                                                            minimumValue: 0,
                                                            maximumValue: 100)),
        // intensity [-1...1], inputColor [CIColor]
        FilterCollectionModel(image: UIImage(named: "WhitePoint")!,
                              filter: Regulations.whitePointAdjust(color: .yellow, intensity: 0.5).getFilter(),
                              firstSliderModel: SliderModel(name: "",
                                                            sliderNumber: 1,
                                                            defaultValue: 0,
                                                            minimumValue: -100,
                                                            maximumValue: 100)),
        // intensity [0...1], radius[1...100 ? ]
        FilterCollectionModel(image: UIImage(named: "Vignette")!,
                              filter: Regulations.vignette(radius: 1, intensity: 1).getFilter(),
                              firstSliderModel: SliderModel(name: "",
                                                            sliderNumber: 1,
                                                            defaultValue: 0,
                                                            minimumValue: 0,
                                                            maximumValue: 100),
                              secondSliderModel: SliderModel(name: "",
                                                             sliderNumber: 1,
                                                             defaultValue: 0,
                                                             minimumValue: 1,
                                                             maximumValue: 100))
    ]
    
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
