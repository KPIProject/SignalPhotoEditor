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
    
    public static let shared = CoreSignalPhotoEditor()
    
    public var sourceImage: UIImage? {
        didSet {
            if let image = sourceImage {
                editedImage = image
                imageStack = [image]
                compressedImage = resizeImage(to: CGSize(width: 120, height: 120))
            }
        }
    }
    
    public var isEditedImageLast: Bool {
        return imageStack.count == editedImageIndex + 1
    }
    
    public var isEditedImageFirst: Bool {
        return editedImageIndex == 0
    }
    
    /// Current displayed image
    public var editedImage: UIImage?
    /// Current displayed image index in stack
    private var editedImageIndex: Int = 0
    private var filteres: [Filter?] = []
    private var imageStack: [UIImage] = []
    private var buffer: (image: UIImage, filter: Filter)?
    
    private(set) var compressedImage: UIImage?
    
    #if DEBUG
    private init() {
        sourceImage = UIImage(named: "mountain")!
        editedImage = UIImage(named: "mountain")!
        imageStack = [UIImage(named: "mountain")!]
        compressedImage = resizeImage(to: CGSize(width: 120, height: 120))
    }
    #endif
    
    public func applyFilter(_ filter: Filter, complition: @escaping (UIImage) -> Void) {
        
        guard var editedImage = editedImage,
              var ciImage = CIImage(image: editedImage) else {
            return
        }
        
        let context = CIContext()
        
        DispatchQueue.global(qos: .userInteractive).async { [self] in
            
            filter.applyFilter(image: &ciImage)
            
            // attempt to get a CGImage from our CIImage
            if let newCGImage = context.createCGImage(ciImage, from: ciImage.extent) {
                // convert that to a UIImage
                editedImage = UIImage(cgImage: newCGImage)
            }
            
            buffer = (image: editedImage, filter: filter)
            
            DispatchQueue.main.async {
                complition(editedImage)
            }
        }
    }
    
    public func confirmFilter() {
        removeOldFilters()
        filteres.append(buffer?.filter)
        imageStack.append((buffer?.image ?? editedImage) ?? UIImage())
        editedImageIndex += 1
        self.editedImage = buffer?.image
    }
    
    public func applyFilterToCompressed(_ filter: Filter, completion: @escaping (UIImage) -> Void) {
                
        guard var editedImage = compressedImage else { return }
        guard var ciImage = CIImage(image: editedImage) else { return }
        let context = CIContext()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            filter.applyFilter(image: &ciImage)
            
            // attempt to get a CGImage from our CIImage
            if let newCGImage = context.createCGImage(ciImage, from: ciImage.extent) {
                // convert that to a UIImage
                editedImage = UIImage(cgImage: newCGImage)
            }
                        
            DispatchQueue.main.async {
                completion(editedImage)
            }
        }
    }
    
    public func applyFiltersToCompressed(completion: @escaping ([FilterCollectionModel]) -> Void) {
        
        var filters = [FilterCollectionModel]()
        
        let sliderModel = SliderModel(name: nil, sliderNumber: 1, defaultValue: 100, minimumValue: 0, maximumValue: 100)

        Filters.allCases.forEach { filter in
            self.applyFilterToCompressed(filter) { image in
                filters.append(FilterCollectionModel(image: image, filter: filter, firstSliderModel: sliderModel))
                if filters.count == Filters.allCases.count {
                    completion(filters.sorted { $0.filter.filterName < $1.filter.filterName })
                }
            }
        }
    }
    
    public func getLUT(completion: @escaping (UIImage) -> Void) {
        
        guard var initialLUT = UIImage(named: "ClearLUT"),
              var ciImage = CIImage(image: initialLUT) else {
            return
        }
        
        let context = CIContext()
        
        DispatchQueue.global(qos: .userInteractive).async { [self] in
            
            for filter in filteres {
                if let filterNotNil = filter {
                    filterNotNil.applyFilter(image: &ciImage)
                } else {
                    if let clearLUTCIImage = CIImage(image: initialLUT) {
                        ciImage = clearLUTCIImage
                    }
                }
            }
            
            // attempt to get a CGImage from our CIImage
            if let newCGImage = context.createCGImage(ciImage, from: ciImage.extent) {
                // convert that to a UIImage
                initialLUT = UIImage(cgImage: newCGImage)
            }
            
            DispatchQueue.main.async {
                completion(initialLUT)
            }
        }
    }
    
    /**
     Returns image there was before last filter appling.
     */
    public func cancelLastFilter() -> UIImage {
        if editedImageIndex > 0 {
            editedImageIndex -= 1
            editedImage = imageStack[editedImageIndex]
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
            editedImage = imageStack[editedImageIndex]
            return imageStack[editedImageIndex]
        } else {
            return imageStack[editedImageIndex]
        }
    }
    
    /**
     Returns original image.
     */
    public func restoreImage(){
        guard let sourceImage = sourceImage else {
            return
        }
        editedImageIndex += 1
        editedImage = sourceImage
        imageStack.append(sourceImage)
        filteres.append(nil)
    }
    
    /**
     Remooves filteres from filteres array which are no longer needed.
     */
    private func removeOldFilters() {
        if imageStack.count != editedImageIndex + 1 {
            imageStack.removeSubrange(editedImageIndex + 1..<imageStack.count)
            filteres.removeSubrange(editedImageIndex..<imageStack.count)
        }
    }
}
