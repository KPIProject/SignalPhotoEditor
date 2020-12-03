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
                // inputEV[-2...2]
                FilterModel(image: UIImage(named: "Exposure")!, name: "Exposure"),
                // inputPower[0...6]
                FilterModel(image: UIImage(named: "Gamma")!, name: "Gamma"),
                // inputAngle[-180...180]
                FilterModel(image: UIImage(named: "Hue")!, name: "Hue"),
                // inputTemperatute[-4000..0.+9000]
                FilterModel(image: UIImage(named: "Temperature")!, name: "Temperature"),
                // inputTint[-100...100]
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
    
    // MARK: - IBActions
    
    @IBAction func doneAction(_ sender: UIButton) {
        
        toogleBottomView()
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        toogleBottomView()
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
                tabBar.isHidden = true
            }
        } else {
            tabBar.isHidden = false
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
    
    func didTapOn(filer: FilterModel) {
        
        toogleBottomView()

        switch state {
        case .filter:
            
            
            if filer.name == "Chrome" {
                sliderControllerView.config(firstSliderModel:
                                                SliderModel(name: "Intesity",
                                                            sliderNumber: 1,
                                                            defaultValue: 50,
                                                            minimumValue: 0,
                                                            maximumValue: 100))
                sliderControllerView.showInStackView(animated: true)
            }
            
            if filer.name == "Fade" {
                sliderControllerView.config(firstSliderModel:
                                                SliderModel(name: "Intesity",
                                                            sliderNumber: 1,
                                                            defaultValue: 50,
                                                            minimumValue: 0,
                                                            maximumValue: 100),
                                            secondSliderModel:
                                                SliderModel(name: "Intesity2",
                                                            sliderNumber: 2,
                                                            defaultValue: 40,
                                                            minimumValue: -100,
                                                            maximumValue: 100))
                sliderControllerView.showInStackView(animated: true)
                
            }
            bottomStackView.layoutSubviews()
            
        case .regulation:
                        
            switch filer.name {
            case "Brightness":
                coreSignal.applyFilter(Regulations.brightness(value: 0).getFilter()) { image in
                    self.mainImageView.image = image
                }
            case "Saturation":
                print("Saturation")
                coreSignal.applyFilter(Regulations.saturation(value: -20).getFilter()) { image in
                    self.mainImageView.image = image
                }
            case "Contrast":
                print("Contrast")
                coreSignal.applyFilter(Regulations.contrast(value: 3).getFilter()) { image in
                    self.mainImageView.image = image
                }
            case "Exposure":
                print("Exposure")
                coreSignal.applyFilter(Regulations.exposure(value: 0.5).getFilter()) { image in
                    self.mainImageView.image = image
                }
            case "Gamma":
                print("Gamma")
                coreSignal.applyFilter(Regulations.gammaAdjust(value: 0.1).getFilter()) { image in
                    self.mainImageView.image = image
                }
            case "Hue":
                print("Hue")
                coreSignal.applyFilter(Regulations.hueAdjust(value: Float(260 * Double.pi / 180)).getFilter()) { image in
                    self.mainImageView.image = image
                }
            case "Temperature":
                print("Temperature")
                coreSignal.applyFilter(Regulations.temperature(value: -4000).getFilter()) { image in
                    self.mainImageView.image = image
                }
            case "Tint":
                print("Tint")
                coreSignal.applyFilter(Regulations.tint(value: 100).getFilter()) { image in
                    self.mainImageView.image = image
                }
            case "Vibrance":
                print("Vibrance")
                coreSignal.applyFilter(Regulations.vibrance(value: 1).getFilter()) { image in
                    self.mainImageView.image = image
                }
            case "White Point":
                print("White Point")
                coreSignal.applyFilter(Regulations.whitePointAdjust(color: .yellow, intensity: 0.5).getFilter()) { image in
                    self.mainImageView.image = image
                }
            case "Vignette":
                print("Vignette")
                coreSignal.applyFilter(Regulations.vignette(radius: 1, intensity: 1).getFilter()) { image in
                    self.mainImageView.image = image
                }
            default:
                print("Error")
            }
        }
        
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
