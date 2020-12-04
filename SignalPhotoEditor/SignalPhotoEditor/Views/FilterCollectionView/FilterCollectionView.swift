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

    public var imageContentMode: UIView.ContentMode = .scaleAspectFill
    public weak var delegate: FilterCollectionViewDelegate?
    
    // MARK: - Private properties

    private var filterCollectionModels: [FilterCollectionModel] = []
        
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    public func config(with filterModel: [FilterCollectionModel], imageContentMode: UIView.ContentMode = .scaleAspectFill) {
        
        self.imageContentMode = imageContentMode
        filterCollectionModels = filterModel
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
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension FilterCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterCollectionModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath) as? FilterCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let filterCollectionModel = filterCollectionModels[indexPath.row]
        filterCell.textLabel.text = filterCollectionModel.filter.filterName
        filterCell.imageView.image = filterCollectionModel.image
        filterCell.imageView.contentMode = imageContentMode
        
        return filterCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.didTapOn(filterCollectionModel: filterCollectionModels[indexPath.row])
    }
}
