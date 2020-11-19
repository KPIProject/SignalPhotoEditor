//
//  LUTsViewController.swift
//  SignalPhotoEditor
//
//  Created by Anastasia Holovash on 13.11.2020.
//

import UIKit

class LUTsViewController: UIViewController {

    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = image {
            secondImageView.image = image
        }
    }
}
