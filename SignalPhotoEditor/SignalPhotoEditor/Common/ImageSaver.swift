//
//  ImageSaver.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 04.12.2020.
//

import UIKit

class ImageSaver: NSObject {
    
    var completion: ((Bool) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        Loader.hide()
        completion?(error == nil)
    }
}
