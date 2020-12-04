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
    
    // MARK: - Private properties
    
    private var sliderModel: SliderModel?
    
    // MARK: - Public properties
    
    public weak var delegate: SliderViewDelegate?
        
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
    
    public func config(with model: SliderModel) {
        
        sliderModel = model
        
        mainSlider.minimumValue = model.minimumValue
        minimumLabel.text = "\(Int(model.minimumValue))"
        
        mainSlider.maximumValue = model.maximumValue
        maximumLabel.text = "\(Int(model.maximumValue))"

        mainSlider.value = model.defaultValue
        currentValueLabel.text = "\(model.name) \(model.defaultValue)"
    }
    
    // MARK: - IBActions
    
    @IBAction func didChageSliderValue(_ sender: UISlider) {
        
        guard let sliderModel = sliderModel else {
            return
        }
        
        currentValueLabel.text = "\(sliderModel.name) \(Int(sender.value))"
        delegate?.sliderChangeValue(sliderModel.sliderNumber, Int(sender.value))
    }
}
