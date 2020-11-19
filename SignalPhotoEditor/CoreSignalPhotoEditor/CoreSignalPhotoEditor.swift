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
    
    private let sourceImage: UIImage    // remove?
    
    /// Current displayed image
    private var editedImage: UIImage
    private var editedImageIndex: Int = 0
    
    private var filteres: [Filter] = []
    private var imageStack: [UIImage] = []
    
    init(image: UIImage) {
        self.sourceImage = image
        self.editedImage = image
        self.imageStack = [image]
    }
    
    public func applyFilter(_ filter: Filter, complition: @escaping (UIImage) -> Void) {
        removeOldFilters()
        
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
    
    /**
     Returns image there was before last filter appling.
     */
    public func cancelLastFilter() -> UIImage {
        if imageStack.count > 1 {
            editedImageIndex -= 1
            return imageStack[editedImageIndex]
        } else {
            return imageStack[editedImageIndex]
        }
    }
    
    /**
     Returns image there was before cancel last filter.
     */
    public func applyBackFilter() -> UIImage {
        if imageStack.count > editedImageIndex + 1 {
            editedImageIndex += 1
            return imageStack[editedImageIndex]
        } else {
            return imageStack[editedImageIndex]
        }
    }
    
    /**
     Returns original image.
     */
    public func restoreImage() -> UIImage {
        return sourceImage
    }
    
    /**
     Remooves filteres from filteres array which are no longer needed.
     */
    private func removeOldFilters() {
        if imageStack.count != editedImageIndex + 1 {
            imageStack.removeSubrange(editedImageIndex + 1..<imageStack.count)
            filteres.removeSubrange(editedImageIndex + 1..<imageStack.count)
        }
    }
    
}
