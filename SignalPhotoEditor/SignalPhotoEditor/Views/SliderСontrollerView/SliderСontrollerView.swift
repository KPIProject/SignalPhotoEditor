//
//  SliderView.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 03.12.2020.
//

import UIKit

final class SliderСontrollerView: UIView, NibLoadable {
    
    // MARK: - IBOutlets
    
    // First sliderView is at the bottom of the stack
    @IBOutlet weak var firstSliderView: SliderView!
    @IBOutlet weak var secondSliderView: SliderView!
    @IBOutlet weak var thirdSliderView: SliderView!
    
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
        
        [firstSliderView, secondSliderView, thirdSliderView].forEach { $0?.delegate = self }
        
        secondSliderView.hideInStackView(animated: false)
        thirdSliderView.hideInStackView(animated: false)
    }
    
    public func config(firstSliderModel: SliderModel,
                       secondSliderModel: SliderModel? = nil,
                       thirdSliderModel: SliderModel? = nil) {
        
        firstSliderView.config(with: firstSliderModel)
        
        if let secondSliderModel = secondSliderModel {
            secondSliderView.config(with: secondSliderModel)
            secondSliderView.showInStackView(animated: true)
        } else {
            secondSliderView.hideInStackView(animated: true)
        }
        
        if let thirdSliderModel = thirdSliderModel {
            thirdSliderView.config(with: thirdSliderModel)
            thirdSliderView.showInStackView(animated: true)
        } else {
            thirdSliderView.hideInStackView(animated: true)
        }
    }
}

// MARK: - SliderViewDelegate

extension SliderСontrollerView: SliderViewDelegate {
    
    func slider(_ sliderModel: SliderModel, didChangeValue newValue: Int) {
        
        delegate?.slider(sliderModel, didChangeValue: newValue)
    }
}
