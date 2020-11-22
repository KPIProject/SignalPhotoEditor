//
//  FilterCollectionView.swift
//  SignalPhotoEditor
//
//  Created by Denys Danyliuk on 22.11.2020.
//

import UIKit

class FilterCollectionView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var filters: [FilterModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadView()
    }
    
    public func config(with filterModel: [FilterModel]) {
        
        collectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "reuseID")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        filters = filterModel
        collectionView.reloadData()
    }

    private func loadView() {
        
        guard let nib = loadNib() else {
            return
        }

        nib.translatesAutoresizingMaskIntoConstraints = false
        nib.backgroundColor = .clear

        addSubview(nib)
        NSLayoutConstraint.activate([
            nib.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nib.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            nib.topAnchor.constraint(equalTo: self.topAnchor),
            nib.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func loadNib() -> UIView? {

        let bundle = Bundle(for: Self.self)
        return bundle.loadNibNamed(String(describing: FilterCollectionView.self), owner: self, options: nil)?.first as? UIView
    }
}

extension FilterCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
        let filter = filters[indexPath.row]
        
        filterCell.textLabel.text = filter.name
        filterCell.imageView.image = filter.image
        
        return filterCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(filters[indexPath.row].name)
    }
}
