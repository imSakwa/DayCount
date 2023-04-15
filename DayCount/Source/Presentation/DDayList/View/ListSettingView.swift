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
        let button =  UIButton(type: .custom)
        let imageConig = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "line.3.horizontal.decrease.circle",
                            withConfiguration: imageConig)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleToFill
      
        return button
    }()
    
    private(set) var moreButton: UIButton = {
        let button = UIButton(type: .custom)
        let imageConig = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "ellipsis.circle",
                            withConfiguration: imageConig)
        button.setImage(image, for: .normal)
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
