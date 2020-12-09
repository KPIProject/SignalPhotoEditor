//
//  FilterViewController.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 26.11.2020.
//

import UIKit

final class FilterViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sliderControllerView: SliderСontrollerView!
    @IBOutlet weak var filterCollectionView: FilterCollectionView!
    
    // MARK: - Private properties
    
    private let imagePicker = ImagePicker(type: .image)
    private let coreSignal = CoreSignalPhotoEditor.shared
    private var state: FilterViewController.State = .filter
    private var currentFilter: GlobalFilter?
    
    private var isFilterActive: Bool = false {
        didSet {
            if oldValue != isFilterActive {
                toogleFilter()
            }
        }
    }
    
    // MARK: - Lifecylce
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupState()
        setupNavigation()
        
        filterCollectionView.delegate = self
        sliderControllerView.delegate = self
        
        sliderControllerView.hideInStackView(animated: false)
        
        if coreSignal.editedImage == nil {
            filterCollectionView.hideInStackView(animated: false)
            addPhotoButton.isHidden = false
        }
        
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        mainImageView.image = coreSignal.editedImage
        
        if coreSignal.editedImage == nil {
            filterCollectionView.hideInStackView(animated: false)
            addPhotoButton.isHidden = false
        } else {
            filterCollectionView.showInStackView(animated: false)
            addPhotoButton.isHidden = true
        }
        
        setupCollectionView()
        setupBarButtonItemsState()
    }
    
    override func viewDidLayoutSubviews() {
        
        bottomViewBottomConstraint.constant = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    }
    
    // MARK: - Setup functions
    
    private func setupState() {
        
        state = navigationController is CustomNavigationController ? .filter : .regulation
    }
    
    private func setupNavigation() {
        
        let selectImageButton = UIBarButtonItem(
            image: UIImage(systemName: "photo.on.rectangle.angled"),
            style: .plain,
            target: self,
            action: #selector(selectImage))
        
        let back = UIBarButtonItem(
            image: UIImage(named: "Back"),
            style: .plain,
            target: self,
            action: #selector(cancelLast))
        
        let forward = UIBarButtonItem(
            image: UIImage(named: "Forward"),
            style: .plain,
            target: self,
            action: #selector(applyBack))
        
        selectImageButton.tintColor = .label
        back.tintColor = .label
        forward.tintColor = .label
        
        navigationItem.leftBarButtonItem = selectImageButton
        navigationItem.rightBarButtonItems = [forward, back]
    }
    
    private func setupCollectionView() {
        
        switch state {
        case .filter:
            
            coreSignal.applyFiltersToCompressed { [weak self] filters in
                self?.filterCollectionView.config(with: filters,
                                                  filterState: .filter,
                                                  originalImage: self?.coreSignal.compressedImage)
            }
            
        case .regulation:
            
            filterCollectionView.config(with: CoreSignalPhotoEditor.filterCollectionModels,
                                        filterState: .regulation)
        }
    }
    
    private func setupBarButtonItemsState() {
        
        navigationItem.rightBarButtonItems?.last?.isEnabled = !coreSignal.isEditedImageFirst
        navigationItem.rightBarButtonItems?.first?.isEnabled = !coreSignal.isEditedImageLast
    }
    
    // MARK: - IBActions
    
    @IBAction func doneAction(_ sender: UIButton) {
        
        if currentFilter != nil {
            coreSignal.confirmFilter()
        } else {
            coreSignal.restoreImage()
        }
        
        setupBarButtonItemsState()
        isFilterActive = false
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        mainImageView.image = coreSignal.editedImage
        isFilterActive = false
    }
    
    @IBAction func addPhotoAction(_ sender: UIButton) {
        selectImage()
    }
    
    @objc
    private func selectImage() {
        
        view.isUserInteractionEnabled = false
        
        imagePicker.setType(type: .image, from: .all).show(in: self) { [weak self] result in
            switch result {
            case let .success(image: image):
                
                self?.coreSignal.config(with: image)
                self?.mainImageView.image = image
                self?.filterCollectionView.showInStackView(animated: true)
                self?.addPhotoButton.isHidden = true

                self?.setupCollectionView()
                
                self?.view.isUserInteractionEnabled = true
                Loader.hide()
                
                self?.setupBarButtonItemsState()
            default:
                self?.view.isUserInteractionEnabled = true
                Loader.hide()
            }
        }
    }
    
    @objc
    private func cancelLast() {
        
        mainImageView.image = coreSignal.cancelLastFilter()
        setupBarButtonItemsState()
    }
    
    @objc
    private func applyBack() {
        
        mainImageView.image = coreSignal.applyBackFilter()
        setupBarButtonItemsState()
    }
    
    private func toogleBottomView() {
        
        guard let tabBar = tabBarController?.tabBar else {
            return
        }
        
        if bottomView.isHidden {
            bottomView.isHidden = false
            UIView.animate(withDuration: 0.35) { [self] in
                bottomView.alpha = 1
                tabBar.alpha = 0
            } completion: { _ in
                tabBar.layer.zPosition = -1
            }
        } else {
            tabBar.layer.zPosition = 0
            UIView.animate(withDuration: 0.35) { [self] in
                tabBar.alpha = 1
                bottomView.alpha = 0
            } completion: { [self] _ in
                bottomView.isHidden = true
            }
        }
    }
    
    private func toogleFilter() {
        
        toogleBottomView()
        
        if isFilterActive {
            if currentFilter != nil {
                sliderControllerView.showInStackView(animated: true)
            }
        } else {
            filterCollectionView.deselect()
            sliderControllerView.hideInStackView(animated: true)
        }
    }
}

// MARK: - FilterCollectionViewDelegate

extension FilterViewController: FilterCollectionViewDelegate {
    
    func didTapOnOrigin() {
        
        mainImageView.image = coreSignal.sourceImage
        currentFilter = nil
        isFilterActive = true
    }
    
    func didTapOnAddLUT() {
        
        imagePicker.setType(type: .image, from: .photoAlbum).show(in: self) { [weak self] result in
            
            guard let self = self else {
                return
            }
            
            switch result {
            
            case let .success(image: image):
                
                let lutFilter = ColorCubeFilter(filterName: "LUT", lutImage: image)
                self.currentFilter = lutFilter
                
                self.sliderControllerView.config(firstSliderModel: SliderModel.positiveSliderMax)
                self.applyFilter(lutFilter)
            case .cancel:
                self.filterCollectionView.deselect()
                Loader.hide()
            default:
                Loader.hide()
            }
        }
    }
    
    func didTapOn(filterModel: FilterModel) {
        
        currentFilter = filterModel.filter
        sliderControllerView.config(firstSliderModel: filterModel.slider)
        
        guard let filter = currentFilter else {
            return
        }
        
        applyFilter(filter)
    }
    
    private func applyFilter(_ filter: GlobalFilter) {
        
//        view.isUserInteractionEnabled = false
//        Loader.show()
//
        coreSignal.applyFilter(filter) { [weak self] image in
            
            if filter.value != 0 {
                self?.mainImageView.image = image
            }
            
            self?.isFilterActive = true
//            self?.view.isUserInteractionEnabled = true
//            Loader.hide()
        }
    }
}

// MARK: - SliderViewDelegate

extension FilterViewController: SliderViewDelegate {
    
    func slider(_ sliderModel: SliderModel, didChangeValue newValue: Int) {
        
        let opacity = abs(Double(newValue) / Double(sliderModel.maximumValue))
        
        if var newFilter = currentFilter {
            
            var extremeValue = Float(opacity)
            extremeValue *= newValue >= 0 ? (currentFilter?.maximumValue ?? 0) : (currentFilter?.minimumValue ?? 0)
            newFilter.value = extremeValue
            
            coreSignal.applyFilter(newFilter, complition: { [weak self] image in
                self?.mainImageView.image = image
            })
        }
    }
}

// MARK: - UIScrollViewDelegate

extension FilterViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainImageView
    }
}

// MARK: - State

extension FilterViewController {
    
    enum State {
        case filter
        case regulation
    }
}
