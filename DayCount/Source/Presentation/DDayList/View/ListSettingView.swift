//
//  ListSettingView.swift
//  DayCount
//
//  Created by ChangMin on 2023/04/12.
//

import UIKit

import SnapKit


final class ListSettingView: UIView {
    
    // MARK: Properties
    
    private let leftStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private let rightStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private(set) var filterButton: UIButton = {
        let button =  UIButton(type: .custom)
        let imageConig = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "line.3.horizontal.decrease.circle",
                            withConfiguration: imageConig)
        button.setImage(image, for: .normal)
      
        return button
    }()
    
    private(set) var plusButton: UIButton = {
        let button = UIButton(frame: .zero)
        let imageConig = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "plus.circle",
                            withConfiguration: imageConig)
        button.setImage(image, for: .normal)
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
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension ListSettingView {
    private func setupLayout() {
        [leftStackView, rightStackView]
            .forEach { addSubview($0) }
        
        [filterButton]
            .forEach { leftStackView.addArrangedSubview($0) }
        [plusButton, moreButton]
            .forEach { rightStackView.addArrangedSubview($0) }
        
        leftStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.height.equalTo(24)
        }
        
        rightStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(24)
        }
        
        filterButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        plusButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        moreButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
}
