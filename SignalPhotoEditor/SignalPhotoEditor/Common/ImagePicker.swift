//
//  ImagePicker.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 26.11.2020.
//

import UIKit
import AVFoundation
import Photos

final class ImagePicker: NSObject {
    
    enum PickerType {
        case image
        case video
        
        var mediaTypes: [String] {
            switch self {
            case .image:
                return ["public.image"]
            case .video:
                return ["public.movie"]
            }
        }
    }
    
    enum FromType {
        case camera
        case photoAlbum
        case all
    }
    
    enum Result {
        
        case success(image: UIImage)
        case successFilePath(_ filePath: URL)
        case denied(errorMessage: String)
        case cancel
    }
    
    typealias Completion = (_ result: Result) -> Void
    
    fileprivate var completion: Completion?
    fileprivate var allowsEditing: Bool = true
    fileprivate var type: PickerType = .image
    fileprivate var from: FromType = .all

    
    init(type: PickerType = .image, from: FromType = .all) {
        super.init()
        
        self.type = type
        self.from = from
    }
    
    func setType(type: PickerType, from: FromType) -> ImagePicker {
        
        self.type = type
        self.from = from
        
        return self
    }
    
    func show(in controller: UIViewController, title: String? = nil, allowsEditing: Bool = true, completion: @escaping Completion) {
        self.completion = completion
        self.allowsEditing = allowsEditing
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
                
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            

            let takePhotoAction = UIAlertAction(title: "Take a picture", style: .default) { [weak self] _ in
                
                let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                
                guard status != .restricted && status != .denied  else {
                    self?.completion = nil
                    return completion(.denied(errorMessage: "Allow \"Signal\" to Have Access to Your Camera"))
                }
                
                self?.presentImagePicker(in: controller, source: .camera)
            }
            
            switch from {
            case .all, .camera:
                alertController.addAction(takePhotoAction)
            default:
                break
            }
        }
        
        let fromDeviceAction = UIAlertAction(title: "From the device", style: .default) { [weak self] _ in
            
            let status = PHPhotoLibrary.authorizationStatus()
            
            guard status != .restricted && status != .denied  else {
                self?.completion = nil
                return completion(.denied(errorMessage: "Allow \"Signal\" to Have Access to Your Photos"))
            }
            
            self?.presentImagePicker(in: controller, source: .photoLibrary)
        }
        
        switch from {
        case .all, .photoAlbum:
            
            alertController.addAction(fromDeviceAction)
        case .camera:
            break
        }
                
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.completion?(.cancel)
            self.completion = nil
        })
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func presentImagePicker(in controller: UIViewController, source: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = allowsEditing
        imagePicker.sourceType = source
        imagePicker.mediaTypes = type.mediaTypes
        imagePicker.navigationBar.backgroundColor = .white
        imagePicker.navigationBar.isTranslucent = false
        
        controller.present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        let uuidStr = UUID().uuidString
        
        switch type {
        case .image:
            guard let image = info[.editedImage] as? UIImage else {
                completion?(.cancel)
                completion = nil
                return
            }
            
            let imageName = "image" + uuidStr + ".jpg"
            
            let filePath = FileManager.default.temporaryDirectory.appendingPathComponent(imageName)
            
            let jpgData = image.jpegData(compressionQuality: 0.8)
            
            do {
                
                try jpgData?.write(to: filePath)
                completion?(.successFilePath(filePath))
                
            } catch let error {
                
                completion?(.cancel)
                print(error)
            }
            completion?(.success(image: image))
            completion = nil
        case .video:
            guard let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
                completion?(.cancel)
                completion = nil
                return
            }
            completion?(.successFilePath(videoUrl))
            completion = nil
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        completion?(.cancel)
        completion = nil
        picker.dismiss(animated: true, completion: nil)
    }
}
