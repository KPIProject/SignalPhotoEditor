//
//  FilterViewController.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 26.11.2020.
//

import UIKit

final class FilterViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var filterCollectionView: FilterCollectionView!
    
    private let imagePicker = ImagePicker(type: .image)
    
    private let coreSignal = CoreSignalPhotoEditor.shared
    
    private var state: FilterViewController.State = .filter
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        state = navigationController is CustomNavigationController ? .filter : .regulation
        scrollView.delegate = self
        setupNavigation()
//        setupCollectionView(image: UIImage())
        
        filterCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print(state)
        mainImageView.image = coreSignal.editedImage
        setupCollectionView(image: coreSignal.compressedImage ?? UIImage())
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
    
    private func setupCollectionView(image: UIImage) {
        
        var filters = [FilterModel]()
        
        switch state {
        case .filter:
            filters = [
                FilterModel(image: image, name: "Filter1"),
                FilterModel(image: image, name: "Filter2"),
                FilterModel(image: image, name: "Filter3"),
                FilterModel(image: image, name: "Filter4"),
                FilterModel(image: image, name: "Filter5"),
                FilterModel(image: image, name: "Filter6")
            ]
            filterCollectionView.config(with: filters)

        case .regulation:
            filters = [
                FilterModel(image: UIImage(named: "brightness")!, name: "Brightness"),
                FilterModel(image: UIImage(named: "saturation")!, name: "Saturation"),
                FilterModel(image: UIImage(named: "contrast")!, name: "Contrast")
            ]
            filterCollectionView.config(with: filters, imageContentMode: .center)
        }
        
    }
    
    @objc
    private func selectImage() {
        imagePicker.setType(type: .image).show(in: self) { [weak self] result in
            switch result {
            
            case let .success(image: image):
                self?.coreSignal.sourceImage = image
                self?.mainImageView.image = image
                self?.setupCollectionView(image: self?.coreSignal.compressedImage ?? UIImage())
            default:
                break
            }
        }
    }
}

extension FilterViewController: FilterCollectionViewDelegate {
    
    func didTapOn(filer: FilterModel) {
        let viewToInsert = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        viewToInsert.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        viewToInsert.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        viewToInsert.backgroundColor = .red
        bottomStackView.insertArrangedSubview(viewToInsert, at: 0)
//        bottomStackView.addArrangedSubview(viewToInsert)
        bottomStackView.layoutSubviews()
        print(bottomStackView.arrangedSubviews)
        print(filer)
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
