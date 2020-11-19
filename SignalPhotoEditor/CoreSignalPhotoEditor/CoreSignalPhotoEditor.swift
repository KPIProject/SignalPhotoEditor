//
//  Interface.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 31.10.2020.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class CoreSignalPhotoEditor {
    
    private let sourceImage: UIImage
    private var editedImage: UIImage
    private var filteres: [Filter] = []
    private var imageStack: [UIImage] = []
    
    init(image: UIImage) {
        self.sourceImage = image
        self.editedImage = image
    }
    
    func applyFilter(_ filter: Filter, complition: @escaping (UIImage) -> Void) {
        
        guard var ciImage = CIImage(image: sourceImage) else { return }
        filteres.append(filter)
        
        let context = CIContext()
        
        DispatchQueue.global(qos: .userInteractive).async { [self] in
            
            filter.applyFilter(image: &ciImage)
            
            // attempt to get a CGImage from our CIImage
            if let newCGImage = context.createCGImage(ciImage, from: ciImage.extent) {
                // convert that to a UIImage
                editedImage = UIImage(cgImage: newCGImage)
            }
            
            imageStack.append(editedImage)
            
            DispatchQueue.main.async {
                complition(editedImage)
            }
        }
    }
    
}
