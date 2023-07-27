//
//  TagCollectionCell.swift
//  DayCount
//
//  Created by ChangMin on 2023/06/06.
//

import UIKit

import SnapKit

protocol TagCollectionCellDelegate: AnyObject {
    func tapCancelButton(index: Int)
}

final class TagCollectionCell: UICollectionViewCell {
    static let identifier = String(describing: TagCollectionCell.self)
    
    weak var delegate: TagCollectionCellDelegate?
    private var index: Int!
    
    // MARK: Properties
    private let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .systemFont(ofSize: 14)
        view.textColor = .black
        return view
    }()
    
    private let cancelButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(systemName: "xmark"), for: .normal)
        view.tintColor = .gray
        return view
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        setupSubviews()
        setupLayouts()
        
        setupCancelButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureCell(text: String, index: Int) {
        titleLabel.text = text
        self.index = index
    }
    
    // MARK: Methods
    private func setupView() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
    }
    
    private func setupSubviews() {
        [titleLabel, cancelButton]
            .forEach { contentView.addSubview($0) }
    }
    
    private func setupLayouts() {
        titleLabel.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(8)
        }
        
        cancelButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.size.equalTo(12)
        }
    }
    
    private func setupCancelButton() {
        cancelButton.addTarget(self, action: #selector(tapCancelButton), for: .touchUpInside)
    }
    
    @objc private func tapCancelButton(_ sender: UIButton) {
        delegate?.tapCancelButton(index: index)
    }
}
