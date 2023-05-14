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
    
    private weak var listSettingDelegate: ListSettingDelegate?
        
    private let rightStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
        
    private let plusButton: UIButton = {
        let button = UIButton(frame: .zero)
        let imageConig = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "plus.circle",
                            withConfiguration: imageConig)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let styleButton: UIButton = {
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
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initView()
    }
}

// MARK: - Methods

extension ListSettingView {
    private func initView() {
        setupSubviews()
        setupLayouts()
        setupAddButton()
        setupStyleButton()
    }
    
    private func setupSubviews() {
        [rightStackView]
            .forEach { addSubview($0) }
        [plusButton, styleButton]
            .forEach { rightStackView.addArrangedSubview($0) }
    }
    
    private func setupLayouts() {
        rightStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(24)
        }
                
        plusButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        styleButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    private func setupAddButton() {
        let addAction = UIAction { _ in
            self.listSettingDelegate?.addButtonTap()
        }
        plusButton.addAction(addAction, for: .touchUpInside)
    }
    
    private func setupStyleButton() {
        let styleAction = UIAction { _ in
            self.listSettingDelegate?.styleButtonTap()
        }
        styleButton.addAction(styleAction, for: .touchUpInside)
    }
    
    func setupListSettingDelegate(_ delegate: ListSettingDelegate) {
        listSettingDelegate = delegate
    }
}
