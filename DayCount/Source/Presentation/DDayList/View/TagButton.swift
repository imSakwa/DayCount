//
//  TagView.swift
//  DayCount
//
//  Created by ChangMin on 2023/05/16.
//

import UIKit

import SnapKit


final class TagButton: UIButton {
    
    // MARK: Properties
        
    private weak var tagButtonDelegate: TagButtonDelegate?
    
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
        setupTagButton()
    }
    
    private func setupTagButton() {
        setTitleColor(.black, for: .normal)
        addTarget(self, action: #selector(tagButtonTap), for: .touchUpInside)
    }
    
    @objc private func tagButtonTap(_ sender: UIButton) {
        if let title = sender.titleLabel?.text {
            tagButtonDelegate?.tagButtonTap(tagTitle: title)
        }
    }
    
    func setupContent(with tag: Tag) {
        setTitle(tag.title, for: .normal)
    }
    
    func setupTagButtonDelegate(_ delegate: TagButtonDelegate?) {
        tagButtonDelegate = delegate
    }
}
