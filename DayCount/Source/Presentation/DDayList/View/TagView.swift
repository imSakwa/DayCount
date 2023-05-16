//
//  TagView.swift
//  DayCount
//
//  Created by ChangMin on 2023/05/16.
//

import UIKit

import SnapKit


final class TagView: UIView {
    
    // MARK: Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "테스트"
        return label
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
    
    // MARK: Methods
    private func initView() {
        setupSubviews()
        setupLayouts()
        setupBaseView()
    }
    
    private func setupSubviews() {
        [titleLabel]
            .forEach { addSubview($0) }
    }
    
    private func setupLayouts() {
        titleLabel.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview().inset(4)
        }
    }
    
    private func setupBaseView() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
    }
}
