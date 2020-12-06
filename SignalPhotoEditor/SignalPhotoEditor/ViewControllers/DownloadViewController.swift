//
//  DownloadViewController.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 04.12.2020.
//

import UIKit

final class DownloadViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var editedImageView: UIImageView!
    @IBOutlet weak var lutImageView: UIImageView!
    @IBOutlet weak var downloadImageButton: UIButton!
    @IBOutlet weak var downloadLUTButton: UIButton!
    
    // MARK: - Private properties
    
    private let coreSignal = CoreSignalPhotoEditor.shared
    private let imageSaver = ImageSaver()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageSaver.completion = { [weak self] isSuceess in
            
            let title = isSuceess ? "Saved" : "Error"
            
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self?.present(alert, animated: true)
        }
        
        view.isUserInteractionEnabled = false
        Loader.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        view.isUserInteractionEnabled = false
        Loader.show()
        
        editedImageView.image = coreSignal.editedImage
        
        coreSignal.getLUT { [weak self] image in
            
            self?.lutImageView.image = image
            self?.view.isUserInteractionEnabled = true
            Loader.hide()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func didPressDownloadButton(_ sender: UIButton) {
        
        guard let imageToSave = coreSignal.editedImage else {
            return
        }
        
        Loader.show()
        imageSaver.writeToPhotoAlbum(image: imageToSave)
    }
    
    @IBAction func didPressDownloadLUT(_ sender: UIButton) {
        
        Loader.show()
        if let image = lutImageView.image {
            imageSaver.writeToPhotoAlbum(image: image)
        }
    }
}
