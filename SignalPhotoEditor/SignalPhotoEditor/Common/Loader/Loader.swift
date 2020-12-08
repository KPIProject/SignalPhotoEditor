//
//  Loader.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 05.12.2020.
//

import UIKit
import SVProgressHUD

struct Loader {
    
    static func show() {
        
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    static func show(with progress: Float) {
        DispatchQueue.main.async {
            SVProgressHUD.showProgress(progress)
        }
    }
}
