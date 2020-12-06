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
    private var filteres: [GlobalFilter?] = []
    private var imageStack: [UIImage] = []
    private var buffer: (image: UIImage, filter: GlobalFilter)?
    
    private(set) var compressedImage: UIImage?
    
    #if DEBUG
    private init() {
        sourceImage = UIImage(named: "mountain")!
        editedImage = UIImage(named: "mountain")!
        imageStack = [UIImage(named: "mountain")!]
        compressedImage = resizeImage(to: CGSize(width: 120, height: 120))
    }
    #endif
    
    public func generateImages(for filter: GlobalFilter,
                               complition: @escaping ((positiveImage: UIImage, negativeImage: UIImage?)) -> Void) {
        guard let editedImage = editedImage,
              var ciImagePositive = CIImage(image: editedImage),
              var ciImageNegative = CIImage(image: editedImage) else {
            return
        }
        
        let context = CIContext()

        DispatchQueue.global(qos: .userInteractive).async {
            var copyFilter = filter
            
            copyFilter.value = filter.maximumValue
            copyFilter.applyFilter(image: &ciImagePositive)
            
            guard let positiveCGImage = context.createCGImage(ciImagePositive, from: ciImagePositive.extent) else {
                return
            }
            
            if filter.minimumValue == 0 {
                
                DispatchQueue.main.async {
                    complition((positiveImage: UIImage(cgImage: positiveCGImage), negativeImage: nil))
                }
            } else {
                
                copyFilter.value = filter.minimumValue
                copyFilter.applyFilter(image: &ciImageNegative)
                if let negativeCGImage = context.createCGImage(ciImageNegative, from: ciImageNegative.extent) {
                    
                    DispatchQueue.main.async {
                        complition((positiveImage: UIImage(cgImage: positiveCGImage), negativeImage: UIImage(cgImage: negativeCGImage)))
                    }
                }
            }
        }
    }
    
    public func applyFilter(_ filter: GlobalFilter, complition: @escaping (UIImage) -> Void) {
        
        guard var editedImage = editedImage,
              var ciImage = CIImage(image: editedImage) else {
            return
        }
        
        let context = CIContext()
        
//        let cicontext = CIContext(options: [
//            .useSoftwareRenderer : false,
//            .highQualityDownsample : true,
//        ])
//
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
    
    public func addImagesAndSave(_ image1: UIImage?, _ image2: UIImage?, opacity: Double) -> UIImage {
        
        guard let ciImage1 = CIImage(image: image1!),
              let ciImage2 = CIImage(image: image2!) else {
            return UIImage()
        }
        
        let background = ciImage1
        let foreground = ciImage2.applyingFilter(
            "CIColorMatrix", parameters: [
                "inputRVector": CIVector(x: 1, y: 0, z: 0, w: CGFloat(0)),
                "inputGVector": CIVector(x: 0, y: 1, z: 0, w: CGFloat(0)),
                "inputBVector": CIVector(x: 0, y: 0, z: 1, w: CGFloat(0)),
                "inputAVector": CIVector(x: 0, y: 0, z: 0, w: CGFloat(opacity)),
                "inputBiasVector": CIVector(x: 0, y: 0, z: 0, w: 0),
            ])
        
        let composition = CIFilter(
            name: "CISourceOverCompositing",
            parameters: [
                kCIInputImageKey : foreground,
                kCIInputBackgroundImageKey : background
            ])!
        
        if let compositeImage = composition.outputImage{
            return UIImage(ciImage: compositeImage)
        }
        return UIImage()
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
    
    public func applyFiltersToCompressed(completion: @escaping ([FilterModel]) -> Void) {
        
        var filters = [FilterModel]()
        
        Filters.allCases.forEach { filter in
            self.applyFilterToCompressed(filter) { image in
                let model = FilterModel(image: image,
                                        filter: filter)
                filters.append(model)
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
     Removes filteres from filteres array which are no longer needed.
     */
    private func removeOldFilters() {
        if imageStack.count != editedImageIndex + 1 {
            imageStack.removeSubrange(editedImageIndex + 1..<imageStack.count)
            filteres.removeSubrange(editedImageIndex..<imageStack.count)
        }
    }
    
    /**
     Removes all changes.
     */
    public func config(with image: UIImage) {
        
        sourceImage = image
        editedImage = image
        imageStack = [image]
        editedImageIndex = 0
        filteres = []
        compressedImage = resizeImage(to: CGSize(width: 120, height: 120))
    }
}
