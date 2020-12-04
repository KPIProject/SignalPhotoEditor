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
                self?.filterCollectionView.config(state: .filter, with: filters, original: self?.coreSignal.compressedImage)
            }
            
        case .regulation:
            
            filterCollectionView.config(state: .regulation, with: createRegulationsCollectionModels(), imageContentMode: .center, original: nil)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func doneAction(_ sender: UIButton) {
        
        if let currentFilter = currentFilter {
            coreSignal.applyFilter(currentFilter) { [weak self] imageWithFilter in
                self?.mainImageView.image = imageWithFilter
            }
        } else {
            coreSignal.restoreImage()
        }
        
        isFilterActive = false
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        mainImageView.image = coreSignal.editedImage
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
                self?.coreSignal.applyFilter(Filters.colorCube(name: "LUT", lutImage: image).getFilter(), complition: { editedImage in
                    self?.mainImageView.image = editedImage
                })
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
        
        coreSignal.applyFilter(currentFilter, tryFilter: true) { [weak self] imageWithFilter in
            self?.mainImageView.image = imageWithFilter
        }
        
        isFilterActive = true
    }
}

// MARK: - SliderViewDelegate

extension FilterViewController: SliderViewDelegate {
    
    func sliderChangeValue(_ sliderNumber: Int, _ newValue: Float) {
        
        print(sliderNumber)
        print(newValue)
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

// MARK: - Regulation model

extension FilterViewController {
    
    func createRegulationsCollectionModels() -> [FilterCollectionModel] {
        
        return [
            // inputBrightness [-1...1]
            FilterCollectionModel(image: UIImage(named: "Brightness")!,
                                  filter: Regulations.brightness(value: 0).getFilter(),
                                  firstSliderModel: SliderModel(name: "",
                                                                sliderNumber: 1,
                                                                defaultValue: 0,
                                                                minimumValue: -100,
                                                                maximumValue: 100)),
            // inputSaturation [0...1]
            FilterCollectionModel(image: UIImage(named: "Saturation")!,
                                  filter: Regulations.saturation(value: -20).getFilter(),
                                  firstSliderModel: SliderModel(name: "",
                                                                sliderNumber: 1,
                                                                defaultValue: 0,
                                                                minimumValue: 0,
                                                                maximumValue: 100)),
            // inputContrast [0...1]
            FilterCollectionModel(image: UIImage(named: "Contrast")!,
                                  filter: Regulations.contrast(value: 3).getFilter(),
                                  firstSliderModel: SliderModel(name: "",
                                                                sliderNumber: 1,
                                                                defaultValue: 0,
                                                                minimumValue: 0,
                                                                maximumValue: 100)),
            // inputEV[-2...2]
            FilterCollectionModel(image: UIImage(named: "Exposure")!,
                                  filter: Regulations.exposure(value: 0.5).getFilter(),
                                  firstSliderModel: SliderModel(name: "EV",
                                                                sliderNumber: 1,
                                                                defaultValue: 0,
                                                                minimumValue: -200,
                                                                maximumValue: 200)),
            // inputPower[0...6]
            FilterCollectionModel(image: UIImage(named: "Gamma")!,
                                  filter: Regulations.gammaAdjust(value: 0.1).getFilter(),
                                  firstSliderModel: SliderModel(name: "",
                                                                sliderNumber: 1,
                                                                defaultValue: 0,
                                                                minimumValue: 0,
                                                                maximumValue: 60)),
            // inputAngle[-180...180]
            FilterCollectionModel(image: UIImage(named: "Hue")!,
                                  filter: Regulations.hueAdjust(value: Float(260 * Double.pi / 180)).getFilter(),
                                  firstSliderModel: SliderModel(name: "",
                                                                sliderNumber: 1,
                                                                defaultValue: 0,
                                                                minimumValue: -180,
                                                                maximumValue: 180)),
            // inputTemperatute[-4000..0.+9000]
            FilterCollectionModel(image: UIImage(named: "Temperature")!,
                                  filter: Regulations.temperature(value: -4000).getFilter(),
                                  firstSliderModel: SliderModel(name: "",
                                                                sliderNumber: 1,
                                                                defaultValue: 0,
                                                                minimumValue: -4000,
                                                                maximumValue: 9000)),
            // inputTint[-100...100]
            FilterCollectionModel(image: UIImage(named: "Tint")!,
                                  filter: Regulations.tint(value: 100).getFilter(),
                                  firstSliderModel: SliderModel(name: "",
                                                                sliderNumber: 1,
                                                                defaultValue: 0,
                                                                minimumValue: -100,
                                                                maximumValue: 100)),
            // inputAmount [0...1]
            FilterCollectionModel(image: UIImage(named: "Vibrance")!,
                                  filter: Regulations.vibrance(value: 1).getFilter(),
                                  firstSliderModel: SliderModel(name: "",
                                                                sliderNumber: 1,
                                                                defaultValue: 0,
                                                                minimumValue: 0,
                                                                maximumValue: 100)),
            // intensity [-1...1], inputColor [CIColor]
            FilterCollectionModel(image: UIImage(named: "WhitePoint")!,
                                  filter: Regulations.whitePointAdjust(color: .yellow, intensity: 0.5).getFilter(),
                                  firstSliderModel: SliderModel(name: "",
                                                                sliderNumber: 1,
                                                                defaultValue: 0,
                                                                minimumValue: -100,
                                                                maximumValue: 100)),
            // intensity [0...1], radius[1...100 ? ]
            FilterCollectionModel(image: UIImage(named: "Vignette")!,
                                  filter: Regulations.vignette(radius: 1, intensity: 1).getFilter(),
                                  firstSliderModel: SliderModel(name: "",
                                                                sliderNumber: 1,
                                                                defaultValue: 0,
                                                                minimumValue: 0,
                                                                maximumValue: 100),
                                  secondSliderModel: SliderModel(name: "",
                                                                 sliderNumber: 1,
                                                                 defaultValue: 0,
                                                                 minimumValue: 1,
                                                                 maximumValue: 100))
        ]
    }
}
