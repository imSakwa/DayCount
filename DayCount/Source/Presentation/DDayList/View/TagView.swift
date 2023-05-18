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
        return UILabel(frame: .zero)
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
    
    func setupContent(with tag: Tag) {
        titleLabel.text = tag.title
    }
}
