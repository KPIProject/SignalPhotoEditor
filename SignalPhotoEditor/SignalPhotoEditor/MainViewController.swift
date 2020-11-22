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
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var filterCollectionView: FilterCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self

        let filters: [FilterModel] = [
            FilterModel(image: UIImage(named: "mountain")!, name: "Filter1"),
            FilterModel(image: UIImage(named: "mountain")!, name: "Filter2"),
            FilterModel(image: UIImage(named: "mountain")!, name: "Filter3"),
            FilterModel(image: UIImage(named: "mountain")!, name: "Filter4"),
            FilterModel(image: UIImage(named: "mountain")!, name: "Filter5"),
            FilterModel(image: UIImage(named: "mountain")!, name: "Filter6")
        ]
        filterCollectionView.config(with: filters)
        
//        scrollView.contentInset = UIEdgeInsets(top: <#T##CGFloat#>, left: <#T##CGFloat#>, bottom: <#T##CGFloat#>, right: <#T##CGFloat#>)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

}


extension MainViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
}
