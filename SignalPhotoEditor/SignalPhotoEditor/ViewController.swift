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
        applyButton.layer.cornerRadius = 4
        resetButton.layer.cornerRadius = 4
    }
    
    @IBAction func didPressApply(_ sender: UIButton) {
        
    }
    
    @IBAction func didPressReset(_ sender: UIButton) {
        
    }
    
}
