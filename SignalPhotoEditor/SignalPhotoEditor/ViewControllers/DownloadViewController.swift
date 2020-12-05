//
//  DownloadViewController.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 04.12.2020.
//

import UIKit

class DownloadViewController: UIViewController {

    private let coreSignal = CoreSignalPhotoEditor.shared
    private let imageSaver = ImageSaver()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didPressDownloadButton(_ sender: UIButton) {
        
        guard let imageToSave = coreSignal.editedImage else {
            return
        }
        
        Loader.show()
        imageSaver.writeToPhotoAlbum(image: imageToSave)
    }
    
    @IBAction func didPressDownloadLUT(_ sender: UIButton) {
        
        Loader.show()
        coreSignal.getLUT { image in
            self.imageSaver.writeToPhotoAlbum(image: image)
        }
    }
    
}
