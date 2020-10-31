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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
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
