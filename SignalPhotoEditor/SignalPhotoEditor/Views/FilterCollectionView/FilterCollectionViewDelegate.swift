//
//  FilterCollectionViewDelegate.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 03.12.2020.
//

import Foundation

protocol FilterCollectionViewDelegate: class {
    
    func didTapOn(filterCollectionModel: FilterCollectionModel)
    func didTapOnOrigin()
    func didTapOnAddLUT()
}
