//
//  TagStackView.swift
//  DayCount
//
//  Created by ChangMin on 2023/05/14.
//

import UIKit

import SnapKit


final class TagScrollView: UIScrollView {
    
    // MARK: Properties
    
    private let tagStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 12
        stackView.alignment = .leading
        return stackView
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
        setupBaseView()
        setupSubviews()
        setupLayouts()
    }
    
    private func setupBaseView() {
        showsHorizontalScrollIndicator = false
    }
    
    private func setupSubviews() {
        addSubview(tagStackView)
    }
    
    private func setupLayouts() {
        tagStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(8)
            $0.directionalVerticalEdges.equalToSuperview()
        }
    }
    
    func setupContent(with tagList: TagList) {
        tagList.forEach {
            let tagView = TagView()
            tagView.setupContent(with: $0)
            tagStackView.addArrangedSubview(tagView)
        }
    }
}
