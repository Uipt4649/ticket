//
//  NFViewController.swift
//  ticket-uire
//
//  Created by 大場史温 on 2025/08/31.
//

import UIKit

public struct NFHeroHeaderItem {
    public let title: String
    public let image: UIImage
    public init(title: String, image: UIImage) {
        self.title = title
        self.image = image
    }
}

public struct NFCollectionItem {
    public let title: String
    public let description: String
    public let image: UIImage
    public init(title: String, description: String, image: UIImage) {
        self.title = title
        self.description = description
        self.image = image
    }
}

public protocol NFItemConfigurable {
    func configure(with item: NFCollectionItem)
}

public class NFViewController: UIViewController {
    
    private var nfHeroHeaderItem: [NFHeroHeaderItem] = []
    private var nfCollectionItem: [NFCollectionItem] = []
    private var nfSectionTitle: String = ""
    private var onSelectItem: ((NFCollectionItem) -> Void)?
    
    public init(nfHeroHeaderItem: [NFHeroHeaderItem], nfCollectionItem: [NFCollectionItem], nfSectionTitle: String, onSelectItem: ((NFCollectionItem) -> Void)? = nil) {
        self.nfHeroHeaderItem = nfHeroHeaderItem
        self.nfCollectionItem = nfCollectionItem
        self.nfSectionTitle = nfSectionTitle
        self.onSelectItem = onSelectItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let numberOfColumns: CGFloat = 3
    private let spacing: CGFloat = 15
    
    private let nfCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(NFCollectionViewCell.self, forCellWithReuseIdentifier: NFCollectionViewCell.identifier)
        collectionView.register(NFHeroHeaderReusableViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NFHeroHeaderReusableViewHeader.identifier)
        collectionView.register(NFSectionTitleReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NFSectionTitleReusableView.identifier)
        return collectionView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard UIDevice.current.userInterfaceIdiom == .pad else {
            fatalError("this vc only ipad")
        }
        
        view.addSubview(nfCollectionView)
        
        nfCollectionView.delegate = self
        nfCollectionView.dataSource = self
        
        configureConstraints()
    }
    
    /// 画面の回転時のWidth再計算
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.nfCollectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    // MARK: LayoutConstraints
    private func configureConstraints() {
        let itemCollectionViewConstraints = [
            nfCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nfCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            nfCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nfCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(itemCollectionViewConstraints)
    }
    
    // MARK: CellのWidth計算
    private func calculateItemWidth(collectionView: UICollectionView) -> CGFloat {
        let horizontalInsets = spacing * 2
        let totalSpacing = spacing * (numberOfColumns - 1)
        
        let availableWidth = collectionView.bounds.width - horizontalInsets - totalSpacing
        return availableWidth / numberOfColumns
    }
}



extension NFViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: NFCell Section
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        default:
            return nfCollectionItem.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFCollectionViewCell.identifier, for: indexPath) as! NFCollectionViewCell
        cell.configure(nfCollectionItem: self.nfCollectionItem[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section > 0 {
            let width = calculateItemWidth(collectionView: collectionView)
            return CGSize(width: width, height: 250)
        }
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section > 0 {
            return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        }
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        let selectedItem = nfCollectionItem[indexPath.item]
        onSelectItem?(selectedItem)
    }
    
    
    // MARK: NFHeader Section
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NFHeroHeaderReusableViewHeader.identifier, for: indexPath) as! NFHeroHeaderReusableViewHeader
            header.configure(nfHeroHeaderItem: self.nfHeroHeaderItem)
            return header
        } else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NFSectionTitleReusableView.identifier, for: indexPath) as! NFSectionTitleReusableView
            header.configure(nfSectionTitle: nfSectionTitle)
            return header
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 1.5)
        } else {
            return CGSize(width: collectionView.frame.width, height: 30)
        }
    }
}
