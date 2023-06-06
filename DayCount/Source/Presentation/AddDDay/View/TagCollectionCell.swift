//
//  TagCollectionCell.swift
//  DayCount
//
//  Created by ChangMin on 2023/06/06.
//

import UIKit

import SnapKit

final class TagCollectionCell: UICollectionViewCell {
    static let identifier = String(describing: TagCollectionCell.self)
    
    // MARK: Properties
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .systemFont(ofSize: 14)
        view.textColor = .gray
        return view
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initView()
    }
    
    // MARK: Methods
    private func initView() {
        setupView()
        setupSubviews()
        setupLayouts()
    }
    
    private func setupView() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
    }
    
    private func setupSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    private func setupLayouts() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
