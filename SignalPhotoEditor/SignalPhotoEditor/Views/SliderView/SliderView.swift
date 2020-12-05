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
    
    // MARK: - Private properties
    
    private var sliderModel: SliderModel?
    
    // MARK: - Public properties
    
    public weak var delegate: SliderViewDelegate?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupFromNib()
    }
    
    public func config(with model: SliderModel) {
        
        sliderModel = model
        
        mainSlider.minimumValue = model.minimumValue
        mainSlider.maximumValue = model.maximumValue
        
        mainSlider.value = model.defaultValue
        
        if let sliderName = model.name {
            currentValueLabel.text = "\(sliderName) \(Int(model.defaultValue))"
        } else {
            currentValueLabel.text = "\(Int(model.defaultValue))"
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func didChageSliderValue(_ sender: UISlider) {
        
        guard let sliderModel = sliderModel else {
            return
        }
        
        if let sliderName = sliderModel.name {
            currentValueLabel.text = "\(sliderName) \(Int(sender.value))"
        } else {
            currentValueLabel.text = "\(Int(sender.value))"
        }
        
        delegate?.slider(sliderModel, didChangeValue: Int(sender.value))
    }
}
