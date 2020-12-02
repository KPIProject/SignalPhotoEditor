//
//  ViewController.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 31.10.2020.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var showLUTButton: UIButton!
    @IBOutlet weak var useLUTButton: UIButton!
    
    private var originalImage: UIImage?
    
    private var filteres: [Filter] = []
    
    private var lutImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        originalImage = mainImageView.image
    }

    private func setupButtons() {
        applyButton.layer.cornerRadius = 10
        resetButton.layer.cornerRadius = 10
        showLUTButton.layer.cornerRadius = 10
        useLUTButton.layer.cornerRadius = 10
    }
    
    @IBAction func didPressSelectPhotoButton(_ sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true)
    }
    
    @IBAction func didPressApply(_ sender: UIButton) {
        print("Apply pressed")

//        filteres = [Filters.photoEffectFade.getFilter(intensity: 1),
//                                  Filters.colorCube(lutImage: UIImage(named: "ClearLUT")!).getFilter(intensity: 1)]
        
//        let coreSignal = CoreSignalPhotoEditor(image: mainImageView.image!)
//        coreSignal.applyFilter(filteres[0]) { [weak self] editedImage in
//            self?.mainImageView.image = editedImage
//        }
    }
    
    @IBAction func didPressReset(_ sender: UIButton) {
        print("Reset pressed")
        mainImageView.image = originalImage
    }
    
    @IBAction func didPressShowLUT(_ sender: UIButton) {
        print("Show LUT pressed")
        
//        let facadeLUT = CoreSignalPhotoEditor(image: UIImage(named: "ClearLUT")!, filteres: [filteres[0]])
////        var newLUTImage: UIImage
//
//        DispatchQueue.global().async {
//            self.lutImage = facadeLUT.applyFilters()
//            DispatchQueue.main.async {
//                let lutsVC = self.storyboard?.instantiateViewController(withIdentifier: "LUTsViewController") as! LUTsViewController
//                lutsVC.image = self.lutImage
//                self.navigationController?.pushViewController(lutsVC, animated: true)
//
//            }
//        }
    }
    
    @IBAction func didPressUseLUTButton(_ sender: UIButton) {
        print("Use LUT pressed")
//        let facade = CoreSignalPhotoEditor(image: mainImageView.image!, filteres: [Filters.colorCube(lutImage: lutImage ?? UIImage(named: "ClearLUT")!).getFilter(intensity: 1)])
//
//        DispatchQueue.global().async {
//            let image = facade.applyFilters()
//            DispatchQueue.main.async {
//                self.mainImageView.image = image
//            }
//        }
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        dismiss(animated: true) {
            self.mainImageView.image = image
            self.originalImage = self.mainImageView.image
        }
    }
}
