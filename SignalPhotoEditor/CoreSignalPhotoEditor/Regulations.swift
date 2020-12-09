//
//  Regulation.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 02.12.2020.
//

import UIKit

extension CoreSignalPhotoEditor {
    
    static var filterCollectionModels: [FilterModel] = [
        
        FilterModel(image: UIImage(named: "Brightness")!, filter: BrightnessRegulation()),
        FilterModel(image: UIImage(named: "Saturation")!, filter: SaturationRegulation()),
        FilterModel(image: UIImage(named: "Contrast")!, filter: ContrastRegulation()),
        FilterModel(image: UIImage(named: "Exposure")!, filter: ExposureAdjustRegulation()),
        FilterModel(image: UIImage(named: "Gamma")!, filter: GammaAdjustRegulation()),
        FilterModel(image: UIImage(named: "Hue")!, filter: HueAdjustRegulation()),
        FilterModel(image: UIImage(named: "Temperature")!, filter: TemperatureRegulation()),
        FilterModel(image: UIImage(named: "Tint")!, filter: TintRegulation()),
        FilterModel(image: UIImage(named: "Vibrance")!, filter: VibranceRegulation()),
        FilterModel(image: UIImage(named: "Vignette")!, filter: VignetteFilter()),
    ]
}
