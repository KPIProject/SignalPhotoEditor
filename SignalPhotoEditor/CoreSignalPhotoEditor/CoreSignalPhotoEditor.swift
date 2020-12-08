//
//  Interface.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 31.10.2020.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

final class CoreSignalPhotoEditor {
    
    public static let shared = CoreSignalPhotoEditor()
    
    // MARK: - Public properties
    
    /// Current displayed image
    public var editedImage: UIImage?
    
    public var sourceImage: UIImage? {
        didSet {
            if let image = sourceImage {
                editedImage = image
                imageStack = [image]
                filteres = []
                editedImageIndex = 0
                compressedImage = resizeImage(to: CGSize(width: 120, height: 120))
            }
        }
    }
    
    public var isEditedImageLast: Bool {
        if imageStack.isEmpty {
            return true
        } else {
            return imageStack.count == editedImageIndex + 1
        }
    }
    
    public var isEditedImageFirst: Bool {
        return editedImageIndex == 0
    }
    
    // MARK: - Private properties
    
    /// Current displayed image index in stack
    private var editedImageIndex: Int = 0
    private var filteres: [GlobalFilter?] = []
    private var imageStack: [UIImage] = []
    private var buffer: (image: UIImage, filter: GlobalFilter)?
    private(set) var compressedImage: UIImage?
    private let context = CIContext()

    // MARK: - Lifecycle
    
    private init() { }
    
    // MARK: - Public functions
    
    /**
     Removes all changes.
     */
    public func config(with image: UIImage) {
        
        sourceImage = image
    }
    
    public func applyFilter(_ filter: GlobalFilter, complition: @escaping (UIImage) -> Void) {
        
        guard var editedImage = editedImage,
              var ciImage = CIImage(image: editedImage) else {
            return
        }
        
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
        editedImage = buffer?.image
    }
    
    /**
     Render all filters to compressed `editedImage`
     */
    public func applyFiltersToCompressed(completion: @escaping ([FilterModel]) -> Void) {
        
        var filters = [FilterModel]()
        
        Filters.allCases.forEach { filter in
            
            applyFilterToCompressed(filter) { image in
                filters.append(FilterModel(image: image, filter: filter))
                
                if filters.count == Filters.allCases.count {
                    completion(filters.sorted { $0.filter.filterName < $1.filter.filterName })
                }
            }
        }
    }
    
    /**
     Render LUT image for filters
     */
    public func getLUT(completion: @escaping (UIImage) -> Void) {
        
        guard var initialLUT = UIImage(named: "ClearLUT"),
              var ciImage = CIImage(image: initialLUT) else {
            return
        }
                
        DispatchQueue.global(qos: .userInteractive).async { [self] in
            
            for filter in filteres {
                if let filterNotNil = filter {
                    if !(filterNotNil is VignetteFilter) {
                        filterNotNil.applyFilter(image: &ciImage)
                    }
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
    public func restoreImage() {
        
        guard let sourceImage = sourceImage else {
            return
        }
        removeOldFilters()
        filteres.append(nil)
        imageStack.append(sourceImage)
        editedImageIndex += 1
        editedImage = sourceImage
    }
    
    // MARK: - Private functions
    
    /**
     Removes filteres from filteres array which are no longer needed.
     */
    private func removeOldFilters() {
        if imageStack.count != editedImageIndex + 1 {
            imageStack.removeSubrange(editedImageIndex + 1..<imageStack.count)
            filteres.removeSubrange(editedImageIndex..<imageStack.count)
        }
    }
    
    private func applyFilterToCompressed(_ filter: Filter, completion: @escaping (UIImage) -> Void) {
        
        guard var editedImage = compressedImage,
              var ciImage = CIImage(image: editedImage) else {
            return
        }
        
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
}
