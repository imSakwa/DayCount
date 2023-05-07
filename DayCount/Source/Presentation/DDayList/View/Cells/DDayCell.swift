//
//  DDaySquareItemCell.swift
//  DayCount
//
//  Created by ChangMin on 2023/04/25.
//

import UIKit

import SnapKit

enum Section: CaseIterable {
    case main
}

final class DDayCell: UICollectionViewCell {
    // MARK: Properties
    
    static let identifier = String(describing: DDayCell.self)
        
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let dateInfoView: DateInfoView = {
        return DateInfoView(frame: .zero)
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
extension DDayCell {
    
    private func initView() {
        setupBaseView()
        setupSubviews()
        setupLayouts()
    }
    
    private func setupBaseView() {
        contentView.backgroundColor = .systemGray6
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.layer.borderWidth = 3.0
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
    }
    
    private func setupSubviews() {
        [titleLabel, dateInfoView].forEach {
            contentView.addSubview($0) }
    }
    
    private func setupLayouts() {
        titleLabel.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalTo(dateInfoView.snp.leading)
        }

        dateInfoView.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }
    }
    
    func setupContentView(type: DDayListCellType, dday: DDay) {
        titleLabel.text = dday.title
        
        switch type {
        case .list:
            setupListType(with: dday)
        case .square:
            setupSquareType(with: dday)
        }
    }
    
    private func setupListType(with dday: DDay) {
        dateInfoView.setupDateInfo(with: dday)
        
    }
    
    private func setupSquareType(with dday: DDay) {
        dateInfoView.setupDateInfo(with: dday)
        
        updateLayout()
    }
    
    private func updateLayout() {
        titleLabel.snp.remakeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(8)
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalTo(contentView.snp.centerY)
        }
        
        dateInfoView.snp.remakeConstraints {
            $0.top.equalTo(contentView.snp.centerY)
            $0.directionalHorizontalEdges.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    

}
