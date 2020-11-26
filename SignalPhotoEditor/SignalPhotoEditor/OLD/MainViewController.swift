//
//  MainViewController.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 22.11.2020.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageVIew: UIImageView!
    
    @IBOutlet weak var filterCollectionView: FilterCollectionView!
    @IBOutlet weak var filterStackView: UIStackView!
    @IBOutlet weak var regulationStackVIew: UIStackView!
    @IBOutlet weak var downloadStackView: UIStackView!
    
    // MARK: - Lifecycle
    
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
        
        let filterGuesture = UITapGestureRecognizer(target: self, action: #selector(showFilter))
        filterStackView.addGestureRecognizer(filterGuesture)
        
        let regulationGuesture = UITapGestureRecognizer(target: self, action: #selector(showRegulation))
        regulationStackVIew.addGestureRecognizer(regulationGuesture)
    }
    
    @objc
    func showFilter() {
        print("filterTapped")
    }
    
    @objc
    func showRegulation() {
        print("regulationTapped")
    }
}

// MARK: - UIScrollViewDelegate

extension MainViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageVIew
    }
}
