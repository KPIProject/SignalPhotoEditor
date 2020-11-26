//
//  FilterViewController.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 26.11.2020.
//

import UIKit

final class FilterViewController: UIViewController {
    
    private let imagePicker = ImagePicker(type: .image)
    
    private let coreSignal = CoreSignalPhotoEditor.shared
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var filterCollectionView: FilterCollectionView!
    
    private var state: FilterViewController.State = .filter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        state = navigationController is CustomNavigationController ? .filter : .regulation
        scrollView.delegate = self
        setupNavigation()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print(state)
        mainImageView.image = coreSignal.editedImage
    }
    
    private func setupNavigation() {
        
        let selectImageButton = UIBarButtonItem(
            image: UIImage(systemName: "photo.on.rectangle.angled"),
            style: .plain,
            target: self,
            action: #selector(selectImage))
        
        selectImageButton.tintColor = .label
        
        navigationItem.leftBarButtonItem = selectImageButton
    }
    
    private func setupCollectionView() {
        let filters: [FilterModel] = [
            FilterModel(image: UIImage(named: "mountain")!, name: "Filter1"),
            FilterModel(image: UIImage(named: "mountain")!, name: "Filter2"),
            FilterModel(image: UIImage(named: "mountain")!, name: "Filter3"),
            FilterModel(image: UIImage(named: "mountain")!, name: "Filter4"),
            FilterModel(image: UIImage(named: "mountain")!, name: "Filter5"),
            FilterModel(image: UIImage(named: "mountain")!, name: "Filter6")
        ]
        filterCollectionView.config(with: filters)
    }
    
    @objc
    private func selectImage() {
        imagePicker.setType(type: .image).show(in: self) { [weak self] result in
            switch result {
            
            case let .success(image: image):
                self?.coreSignal.sourceImage = image
                self?.mainImageView.image = image
            default:
                break
            }
        }
    }
}

extension FilterViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainImageView
    }
}


extension FilterViewController {
    
    enum State {
        case filter
        case regulation
    }
}
