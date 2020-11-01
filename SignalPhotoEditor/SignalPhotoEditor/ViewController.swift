//
//  ViewController.swift
//  SignalPhotoEditor
//
//  Created by Головаш Анастасия on 31.10.2020.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    private var originalImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        originalImage = mainImageView.image
    }

    private func setupButtons() {
        applyButton.layer.cornerRadius = 10
        resetButton.layer.cornerRadius = 10
    }
    
    @IBAction func didPressApply(_ sender: UIButton) {
        print("Apply pressed")
//        DispatchQueue.g
        let facade = Facade(image: mainImageView.image!, filteres: [Filters.vignette(intensity: 1, radius: 10).getFilter()])
        
        DispatchQueue.global().async {
            let image = facade.applyFilters()
            DispatchQueue.main.async {
                self.mainImageView.image = image
            }
        }
    }
    
    @IBAction func didPressReset(_ sender: UIButton) {
        print("Reset pressed")
        mainImageView.image = originalImage
    }
    
}
