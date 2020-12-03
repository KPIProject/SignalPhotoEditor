//
//  SliderView.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 03.12.2020.
//

import UIKit

final class SliderСontrollerView: UIView, NibLoadable {

    // MARK: - IBOutlets

    @IBOutlet weak var firstSliderView: SliderView!
    @IBOutlet weak var secondSliderView: SliderView!
    @IBOutlet weak var thirdSliderView: SliderView!
    
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
}
