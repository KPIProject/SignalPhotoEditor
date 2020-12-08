//
//  FilterCollectionViewDelegate.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 03.12.2020.
//

import Foundation

protocol FilterCollectionViewDelegate: class {
    
    func didTapOnOrigin()
    func didTapOnAddLUT()
    func didTapOn(filterModel: FilterModel)
}
