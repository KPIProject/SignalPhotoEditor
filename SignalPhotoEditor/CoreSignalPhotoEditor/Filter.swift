//
//  Filter.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 31.10.2020.
//

import UIKit


protocol Filter {
//    var filterName: String? { get }
    var filterEffectValue: Any? { get set }
    var filterEffectValueName: String? { get set }

    func applyFilter(image: inout CIImage)
}
