//
//  UIView+StackView.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 03.12.2020.
//

import UIKit

extension UIView {
    
    /// Hide view in stack if needed
    func hideInStackView(animated: Bool, duration: TimeInterval = 0.35) {
        if !isHidden {
            if animated {
                UIView.animate(withDuration: duration) { [self] in
                    alpha = 0
                    isHidden = true
                    superview?.layoutSubviews()
                }
            } else {
                alpha = 0
                isHidden = true
                superview?.layoutSubviews()
            }
        }
    }
    
    /// Show view in stack if needed
    func showInStackView(animated: Bool, duration: TimeInterval = 0.35) {
        if isHidden {
            if animated {
                UIView.animate(withDuration: duration) { [self] in
                    alpha = 1
                    isHidden = false
                    superview?.layoutSubviews()
                }
            } else {
                alpha = 1
                isHidden = false
                superview?.layoutSubviews()
            }
        }
    }
}
