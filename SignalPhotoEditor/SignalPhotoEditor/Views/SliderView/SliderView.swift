//
//  SliderView.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 03.12.2020.
//

import UIKit

final class SliderView: UIView, NibLoadable {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mainSlider: UISlider!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var minimumLabel: UILabel!
    @IBOutlet weak var maximumLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        
        setupFromNib()
    }
    
    // MARK: - IBActions
    
    @IBAction func didChageSliderValue(_ sender: UISlider) {
        
    }
}
