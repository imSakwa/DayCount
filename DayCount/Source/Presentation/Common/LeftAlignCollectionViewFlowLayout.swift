//
//  LeftAlignCollectionViewFlowLayout.swift
//  DayCount
//
//  Created by ChangMin on 2023/07/28.
//

import UIKit

final class LeftAlignCollectionViewFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 3.0
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        minimumLineSpacing = 3
        minimumInteritemSpacing = 8
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        sectionInset = UIEdgeInsets(top: 6.0, left: 0.0, bottom: 0.0, right: 0.0)
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY = -1.0
        attributes?.forEach {
            if $0.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            $0.frame.origin.x = leftMargin
            leftMargin += $0.frame.width + cellSpacing
            maxY = max($0.frame.maxY, maxY)
        }
        
        return attributes
    }
}
