//
//  DDaySquareItemCell.swift
//  DayCount
//
//  Created by ChangMin on 2023/04/25.
//

import UIKit

import SnapKit

final class DDaySquareItemCell: UICollectionViewCell {
    static let identifier = String(describing: DDaySquareItemCell.self)
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "테스트"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}

extension DDaySquareItemCell {
    private func setupLayout() {
        [titleLabel]
            .forEach {
                contentView.addSubview($0)
            }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
