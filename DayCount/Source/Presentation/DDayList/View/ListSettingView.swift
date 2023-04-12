//
//  ListSettingView.swift
//  DayCount
//
//  Created by ChangMin on 2023/04/12.
//

import UIKit

import SnapKit


final class ListSettingView: UIView {
    
    private(set) var filterButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        return button
    }()
    
    private(set) var moreButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListSettingView {
    private func setupView() {
        [filterButton, moreButton]
            .forEach { addSubview($0) }
        
        filterButton.snp.makeConstraints {
            $0.trailing.equalTo(moreButton.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        moreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
}
