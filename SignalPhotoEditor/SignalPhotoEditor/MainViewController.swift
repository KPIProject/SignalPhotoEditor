//
//  MainViewController.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 22.11.2020.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageVIew: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
    }
    

}


extension MainViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return  imageVIew
    }
}
