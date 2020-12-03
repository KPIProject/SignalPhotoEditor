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
        setupCollectionView()
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
        
        var filters = [FilterModel]()
        
        switch state {
        case .filter:
            
            coreSignal.applyFiltersToCompressed { filters in
                self.filterCollectionView.config(with: filters)
            }

        case .regulation:
            filters = [
                // inputBrightness [-1...1]
                FilterModel(image: UIImage(named: "Brightness")!, name: "Brightness"),
                // inputSaturation [0...1]
                FilterModel(image: UIImage(named: "Saturation")!, name: "Saturation"),
                // inputContrast [0...1]
                FilterModel(image: UIImage(named: "Contrast")!, name: "Contrast"),
                // inputEV[0...1]
                FilterModel(image: UIImage(named: "Exposure")!, name: "Exposure"),
                // inputPower[0...1]
                FilterModel(image: UIImage(named: "Gamma")!, name: "Gamma"),
                // inputAngle[-180...180]
                FilterModel(image: UIImage(named: "Hue")!, name: "Hue"),
                // inputTemperatute[-1000...+1000 ? ]
                FilterModel(image: UIImage(named: "Temperature")!, name: "Temperature"),
                // inputTint[?]
                FilterModel(image: UIImage(named: "Tint")!, name: "Tint"),
                // inputAmount [0...1]
                FilterModel(image: UIImage(named: "Vibrance")!, name: "Vibrance"),
                // intensity [-1...1], inputColor [CIColor]
                FilterModel(image: UIImage(named: "WhitePoint")!, name: "White Point"),
                // intensity [0...1], radius[1...100 ? ]
                FilterModel(image: UIImage(named: "Vignette")!, name: "Vignette"),
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
                self?.setupCollectionView()
            default:
                break
            }
        }
    }
}

extension FilterViewController: FilterCollectionViewDelegate {
    
    func didTapOn(filer: FilterModel) {
//        let viewToInsert = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
//
//        viewToInsert.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
//        viewToInsert.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
//
//        viewToInsert.backgroundColor = .red
//        bottomStackView.insertArrangedSubview(viewToInsert, at: 0)
////        bottomStackView.addArrangedSubview(viewToInsert)
//        bottomStackView.layoutSubviews()
//        print(bottomStackView.arrangedSubviews)
//        print(filer)
        
        
        
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
