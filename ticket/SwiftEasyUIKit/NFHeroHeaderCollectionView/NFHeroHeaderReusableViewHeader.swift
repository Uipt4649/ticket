//
//  NFHeroHeaderReusableViewHeader.swift
//  ticket-uire
//
//  Created by 大場史温 on 2025/09/01.
//

import UIKit

class NFHeroHeaderReusableViewHeader: UICollectionReusableView {
    static let identifier = "NFHeroHeaderReusableViewHeader"
    
    private var nfHeroHeaderItem: [NFHeroHeaderItem] = []
    
    private let nfHeroCollectionView: UICollectionView = {
        let layout = NFHeroHeaderCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NFHeroHeaderCollectionViewCell.self, forCellWithReuseIdentifier: NFHeroHeaderCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(nfHeroCollectionView)
        nfHeroCollectionView.delegate = self
        nfHeroCollectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nfHeroCollectionView.frame = self.bounds
        
        /// 中央にスクロール
        if nfHeroHeaderItem.count > 0 {
            let middleIndex = nfHeroHeaderItem.count / 2
            let middleIndexPath = IndexPath(item: middleIndex, section: 0)
            
            nfHeroCollectionView.scrollToItem(at: middleIndexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(nfHeroHeaderItem: [NFHeroHeaderItem]) {
        self.nfHeroHeaderItem = nfHeroHeaderItem
    }
}

extension NFHeroHeaderReusableViewHeader: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nfHeroHeaderItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFHeroHeaderCollectionViewCell.identifier, for: indexPath) as! NFHeroHeaderCollectionViewCell
        cell.configure(nfHeroHeaderItem: self.nfHeroHeaderItem[indexPath.row])
        
        return cell
    }
}
