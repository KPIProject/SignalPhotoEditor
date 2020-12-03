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
        if self.isHidden == false {
            if animated {
                UIView.animate(withDuration: duration) {
                    self.alpha = 0
                    self.isHidden = true
                    self.superview?.layoutSubviews()
                }
            } else {
                self.alpha = 0
                self.isHidden = true
                self.superview?.layoutSubviews()
            }
        }
    }
    
    /// Show view in stack if needed
    func showInStackView(animated: Bool, duration: TimeInterval = 0.35) {
        if self.isHidden == true {
            if animated {
                UIView.animate(withDuration: duration) {
                    self.alpha = 1
                    self.isHidden = false
                    self.superview?.layoutSubviews()
                }
            } else {
                self.alpha = 1
                self.isHidden = false
                self.superview?.layoutSubviews()
            }
        }
    }
}
