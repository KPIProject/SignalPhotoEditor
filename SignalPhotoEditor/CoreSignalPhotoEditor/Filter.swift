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
    
    func getFilter() -> Filter {
        switch self {
        case let .sepia(intensity: intensity):
            return SepiaFilter(intensity: intensity)
        case let .vignette(intensity: intensity, radius: radius):
            return VignetteFilter(intensity: intensity, radius: radius)
        }
    }
}
