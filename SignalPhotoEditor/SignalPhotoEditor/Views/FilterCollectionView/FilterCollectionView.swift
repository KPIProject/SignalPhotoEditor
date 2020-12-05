//
//  FilterCollectionView.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 22.11.2020.
//

import UIKit

final class FilterCollectionView: UIView, NibLoadable {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Public properties
    
    public weak var delegate: FilterCollectionViewDelegate?
    
    // MARK: - Private properties
    
    private var filterCollectionModels: [FilterCollectionModel] = []
    private var originalImageCompressed : UIImage?
    private var state: FilterViewController.State = .filter
        
    private var selectedIndexPath: IndexPath?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    public func config(with filterModel: [FilterCollectionModel],
                       filterState: FilterViewController.State,
                       originalImage: UIImage? = nil) {
        
        state = filterState
        filterCollectionModels = filterModel
        
        if let original = originalImage {
            originalImageCompressed = original
        }
        
        collectionView.reloadData()
    }
    
    private func setupView() {
        
        setupFromNib()
        backgroundColor = .clear
        
        collectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "reuseID")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    public func deselect() {
        
        guard let selectedIndexPath = selectedIndexPath,
              let filterCell = collectionView.cellForItem(at: selectedIndexPath) as? FilterCollectionViewCell else {
            return
        }
        
        filterCell.textLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.selectedIndexPath = nil
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension FilterCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch state {
        case .filter:
            return filterCollectionModels.count + 2
        case .regulation:
            return filterCollectionModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath) as? FilterCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        var filterCollectionModel: FilterCollectionModel
        
        switch state {
        case .filter:
            
            switch indexPath.row {
            case 0:
                filterCell.textLabel.text = "Original"
                filterCell.imageView.image = originalImageCompressed
            case 1:
                filterCell.textLabel.text = "Add LUT"
                filterCell.imageView.image = UIImage(named: "addLut")
            default:
                filterCollectionModel = filterCollectionModels[indexPath.row - 2]
                filterCell.textLabel.text = filterCollectionModel.filter.filterName
                filterCell.imageView.image = filterCollectionModel.image
            }
            
            filterCell.imageView.contentMode = .scaleAspectFill
            
        case .regulation:
            
            filterCollectionModel = filterCollectionModels[indexPath.row]
            filterCell.textLabel.text = filterCollectionModel.filter.filterName
            filterCell.imageView.image = filterCollectionModel.image
            filterCell.imageView.contentMode = .center
        }
        
        return filterCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard indexPath == selectedIndexPath,
              let filterCell = cell as? FilterCollectionViewCell else {
            return
        }
        
        filterCell.textLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let filterCell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell {
            selectedIndexPath = indexPath
            filterCell.textLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        }
        
        switch state {
        case .filter:
            switch indexPath.row {
            case 0:
                delegate?.didTapOnOrigin()
            case 1:
                delegate?.didTapOnAddLUT()
            default:
                delegate?.didTapOn(filterCollectionModel: filterCollectionModels[indexPath.row - 2])
            }
        case .regulation:
            delegate?.didTapOn(filterCollectionModel: filterCollectionModels[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let filterCell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell else {
            return
        }
        filterCell.textLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    }
}
