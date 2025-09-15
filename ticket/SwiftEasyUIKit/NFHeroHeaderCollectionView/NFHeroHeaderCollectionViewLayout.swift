//
//  NFHeroHeaderCollectionViewLayout.swift
//  ticket-uire
//
//  Created by 大場史温 on 2025/09/02.
//

import UIKit

class NFHeroHeaderCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else { return }
        let itemWidth = collectionView.bounds.height * 0.65
        let itemHeight = collectionView.bounds.height * 0.65
        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        self.scrollDirection = .horizontal
                
        let horizontalInset = (collectionView.bounds.width - itemWidth) / 2
        self.sectionInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }
        let pageWidth = itemSize.width + minimumLineSpacing
        let currentPage = collectionView.contentOffset.x / pageWidth
        
        if abs(velocity.x) > 0.2 {
            let nextPage = (velocity.x > 0) ? ceil(currentPage) : floor(currentPage)
            return CGPoint(x: nextPage * pageWidth, y: proposedContentOffset.y)
        } else {
            return CGPoint(x: round(currentPage) * pageWidth, y: proposedContentOffset.y)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect), let collectionView = self.collectionView else {
            return nil
        }
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        
        for attribute in attributes where attribute.frame.intersects(visibleRect) {
            // セルの中心と画面の中心との距離を計算
            let distance = visibleRect.midX - attribute.center.x
            
            // 距離に基づいてスケール(大きさ)を計算 (最大1.0, 最小0.8など)
            let scale = max(1 - abs(distance) / (collectionView.bounds.width), 0.8)
            
            // 3Dの回転と視差効果を適用
            var transform = CATransform3DIdentity
            transform.m34 = -1.0 / 500.0 // 視差効果
            transform = CATransform3DRotate(transform, distance / (itemSize.width) * 0.5, 0, 1, 0) // Y軸回転
            transform = CATransform3DScale(transform, scale, scale, 1) // 縮小
            
            attribute.transform3D = transform
            attribute.zIndex = Int(scale * 100)
        }
        
        return attributes
    }
}
