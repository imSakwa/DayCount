//
//  TagInputView.swift
//  DayCount
//
//  Created by ChangMin on 2023/06/06.
//

import UIKit

import SnapKit

final class TagInputView: UIView {
    
    // MARK: Properties
    private let tagTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "#태그 입력 (최대 3개)"
        return view
    }()
    
    private let tagCollectionView: UICollectionView = {
        let layout = LeftAlignCollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isScrollEnabled = false
        view.register(TagCollectionCell.self, forCellWithReuseIdentifier: TagCollectionCell.identifier)
        return view
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Methods
    
    func setupTagCollectionViewDataSource(_ delegate: UICollectionViewDataSource) {
        tagCollectionView.dataSource = delegate
    }
    
    func setupTagTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        tagTextField.delegate = delegate
    }
    
    private func initView() {
        setupSubviews()
        setupLayouts()
    }
    
    private func setupSubviews() {
        [tagTextField, tagCollectionView]
            .forEach {
                addSubview($0)
            }
    }
    
    private func setupLayouts() {
        tagTextField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(tagTextField.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func reloadCollectionView() {
        tagCollectionView.reloadData()
    }
}
