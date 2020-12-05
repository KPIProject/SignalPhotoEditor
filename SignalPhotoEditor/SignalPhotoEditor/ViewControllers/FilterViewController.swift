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
    private var currentFilter: GlobalFilter?
    private var currentIntensity: Float?
    
    private var currentFilterImages: (positiveImage: UIImage?, negativeImage: UIImage?)?
    
    private var isFilterActive: Bool = false {
        didSet {
            if oldValue != isFilterActive {
                toogleBottomView()
                
                if isFilterActive {
                    sliderControllerView.showInStackView(animated: true)
                } else {
                    filterCollectionView.deselect()
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
        setupBarButtonItemsState()
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
    
    private func setupBarButtonItemsState() {
        
        navigationItem.rightBarButtonItems?.last?.isEnabled = coreSignal.isEditedImageFirst ? false : true
        navigationItem.rightBarButtonItems?.first?.isEnabled = coreSignal.isEditedImageLast ? false : true
    }
    
    // MARK: - IBActions
    
    @IBAction func doneAction(_ sender: UIButton) {
        
        if currentFilter != nil {
            view.isUserInteractionEnabled = false
            Loader.show()
            
            if var fliter = currentFilter {
                fliter.value = currentIntensity ?? 0
                coreSignal.applyFilter(fliter) { [weak self] _ in
                    self?.coreSignal.confirmFilter()
                    self?.mainImageView.image = self?.coreSignal.editedImage
                    self?.view.isUserInteractionEnabled = true
                    
                    self?.overlayImageView.image = nil
                    self?.overlayImageView.isHidden = true
                    Loader.hide()
                    self?.setupBarButtonItemsState()
                }
            }
            
        } else {
            coreSignal.restoreImage()
            setupBarButtonItemsState()
        }
        
        mainImageView.alpha = 1

        isFilterActive = false
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        overlayImageView.image = nil
        overlayImageView.isHidden = true
        
        mainImageView.alpha = 1
        isFilterActive = false
    }
    
    @objc
    private func selectImage() {
        
        imagePicker.setType(type: .image, from: .all).show(in: self) { [weak self] result in
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
                
                let lutFilter = Filters.colorCube(name: "LUT", lutImage: image).getFilter()
                self.currentFilter = lutFilter

                self.sliderControllerView.config(firstSliderModel: SliderModel.positiveSliderMax)
                self.applyFilter(lutFilter)
            case .cancel:
                self.filterCollectionView.deselect()
            default:
                break
            }
        }
    }
    
    func didTapOn(filterModel: FilterModel) {
        
        currentFilter = filterModel.filter
        sliderControllerView.config(firstSliderModel: filterModel.slider)
        currentIntensity = filterModel.filter.value
        
        guard let filter = currentFilter else {
            return
        }
        
        applyFilter(filter)
    }
    
    private func applyFilter(_ filter: GlobalFilter) {
        view.isUserInteractionEnabled = false
        Loader.show()
        
        coreSignal.generateImages(for: filter) { [weak self] images in
            self?.currentFilterImages = images
            
            if filter is Filter {
                self?.overlayImageView.image = images.positiveImage
            }
            self?.overlayImageView.isHidden = false

            self?.isFilterActive = true
            self?.view.isUserInteractionEnabled = true
            Loader.hide()
        }
        
//        coreSignal.applyFilter(filter) { [weak self] imageWithFilter in
//
//            self?.overlayImageView.image = imageWithFilter
//            self?.overlayImageView.isHidden = false
//            self?.currentIntensity = 1.0
//
//            self?.view.isUserInteractionEnabled = true
//            self?.isFilterActive = true
//            Loader.hide()
//        }
    }
}

// MARK: - SliderViewDelegate

extension FilterViewController: SliderViewDelegate {
    
    
    func slider(_ sliderModel: SliderModel, didChangeValue newValue: Int) {
        
        let opacity = abs(Double(newValue) / Double(sliderModel.maximumValue))

        if newValue >= 0 {
            
//            overlayImageView.image = currentFilterImages?.positiveImage
            currentIntensity = Float(opacity) * (currentFilter?.maximumValue ?? 0)
        } else {
            
//            overlayImageView.image = currentFilterImages?.negativeImage
            currentIntensity = Float(opacity) * (currentFilter?.minimumValue ?? 0)
        }
        var newFilter = currentFilter
        newFilter?.value = currentIntensity ?? 0
        
        coreSignal.applyFilter(newFilter!) { newImage in
            print("applying")
            self.overlayImageView.image = newImage
        }
        print("opacity", opacity)
//        mainImageView.alpha = 1 - CGFloat(opacity)
        overlayImageView.alpha = 1.0
    }
    
    func addImages(_ image1: UIImage?, _ image2: UIImage?, opacity: Double) -> UIImage {
        
        guard let ciImage1 = CIImage(image: image1!),
              let ciImage2 = CIImage(image: image2!) else {
            return UIImage()
        }
        
        let background = ciImage1
        let foreground = ciImage2.applyingFilter(
            "CIColorMatrix", parameters: [
                "inputRVector": CIVector(x: 1, y: 0, z: 0, w: CGFloat(0)),
                "inputGVector": CIVector(x: 0, y: 1, z: 0, w: CGFloat(0)),
                "inputBVector": CIVector(x: 0, y: 0, z: 1, w: CGFloat(0)),
                "inputAVector": CIVector(x: 0, y: 0, z: 0, w: CGFloat(opacity)),
                "inputBiasVector": CIVector(x: 0, y: 0, z: 0, w: 0),
            ])
        
        let composition = CIFilter(
            name: "CISourceOverCompositing",
            parameters: [
                kCIInputImageKey : foreground,
                kCIInputBackgroundImageKey : background
            ])!
        
        if let compositeImage = composition.outputImage{
            return UIImage(ciImage: compositeImage)
            // do something with the "merged" image
        }
        return UIImage()
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
