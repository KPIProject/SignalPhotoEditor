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
    @IBOutlet weak var overlayImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var sliderControllerView: SliderСontrollerView!
    @IBOutlet weak var filterCollectionView: FilterCollectionView!
    
    // MARK: - Private properties
    
    private let imagePicker = ImagePicker(type: .image)
    private let coreSignal = CoreSignalPhotoEditor.shared
    private var state: FilterViewController.State = .filter
    private var currentFilter: Filter?
        
    private var isFilterActive: Bool = false {
        didSet {
            if oldValue != isFilterActive {
                toogleBottomView()
                
                if isFilterActive {
                    sliderControllerView.showInStackView(animated: true)
                } else {
                    sliderControllerView.hideInStackView(animated: true)
                }
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
        scrollView.delegate = self
        overlayImageView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        mainImageView.image = coreSignal.editedImage
        setupCollectionView()
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
            
            filterCollectionView.config(with: Regulations.filterCollectionModels,
                                        filterState: .regulation)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func doneAction(_ sender: UIButton) {
        
        if currentFilter != nil {
            coreSignal.confirmFilter()
        } else {
            coreSignal.restoreImage()
        }
        
        mainImageView.image = coreSignal.editedImage
        
        overlayImageView.image = nil
        overlayImageView.isHidden = true
        
        isFilterActive = false
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        overlayImageView.image = nil
        overlayImageView.isHidden = true
        isFilterActive = false
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
    
    @objc
    private func cancelLast() {
        
        mainImageView.image = coreSignal.cancelLastFilter()
    }
    
    @objc
    private func applyBack() {
        
        mainImageView.image = coreSignal.applyBackFilter()
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
}

// MARK: - FilterCollectionViewDelegate

extension FilterViewController: FilterCollectionViewDelegate {
    
    func didTapOnOrigin() {
        mainImageView.image = coreSignal.sourceImage
        currentFilter = nil
        isFilterActive = true
    }
    
    func didTapOnAddLUT() {
        
        imagePicker.setType(type: .image).show(in: self) { [weak self] result in
            
            switch result {
            
            case let .success(image: image):
                self?.coreSignal.applyFilter(Filters.colorCube(name: "LUT", lutImage: image).getFilter()) { editedImage in
                    self?.overlayImageView.image = editedImage
                    self?.overlayImageView.isHidden = false
                }
            default:
                break
            }
        }
    }
    
    func didTapOn(filterCollectionModel: FilterCollectionModel) {
        
        currentFilter = filterCollectionModel.filter
        
        sliderControllerView.config(firstSliderModel: filterCollectionModel.firstSliderModel,
                                    secondSliderModel: filterCollectionModel.secondSliderModel,
                                    thirdSliderModel: filterCollectionModel.thirdSliderModel)
        
        guard let currentFilter = currentFilter else {
            return
        }
        
        coreSignal.applyFilter(currentFilter) { [weak self] imageWithFilter in
            self?.overlayImageView.image = imageWithFilter
            self?.overlayImageView.isHidden = false
        }
        
        isFilterActive = true
    }
}

// MARK: - SliderViewDelegate

extension FilterViewController: SliderViewDelegate {
    
    
    func slider(_ sliderModel: SliderModel, didChangeValue newValue: Int) {
        
        let opacity = Double(newValue) / Double(sliderModel.maximumValue)
        overlayImageView.alpha = CGFloat(opacity)
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
