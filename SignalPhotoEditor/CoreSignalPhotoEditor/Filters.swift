//
//  Filter.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 31.10.2020.
//

import UIKit


extension CoreSignalPhotoEditor {
    
    static var allCases: [Filter] = [
        SepiaFilter(),
        PhotoEffectChromeFilter(),
        PhotoEffectFadeFilter(),
        PhotoEffectMonoFilter(),
        MaximumComponentFilter(),
        MinimumComponentFilter(),
        PhotoEffectInstantFilter(),
        PhotoEffectNoirFilter(),
        PhotoEffectProcessFilter(),
        PhotoEffectTonalFilter(),
        PhotoEffectTransferFilter(),
        ColorInvertFilter(),
        ColorPosterizeFilter(),
        ColorCubeFilter(filterName: "Persian", lutImage: UIImage(named: "Persian") ?? UIImage()),
        ColorCubeFilter(filterName: "Autumn", lutImage: UIImage(named: "Autumn") ?? UIImage()),
        ColorCubeFilter(filterName: "Cake", lutImage: UIImage(named: "Cake") ?? UIImage()),
        ColorCubeFilter(filterName: "Coffee", lutImage: UIImage(named: "Coffee") ?? UIImage()),
        ColorCubeFilter(filterName: "Field", lutImage: UIImage(named: "Field") ?? UIImage()),
        ColorCubeFilter(filterName: "Flamingo", lutImage: UIImage(named: "Flamingo") ?? UIImage()),
        ColorCubeFilter(filterName: "Jungle", lutImage: UIImage(named: "Jungle") ?? UIImage()),
    ]
}
