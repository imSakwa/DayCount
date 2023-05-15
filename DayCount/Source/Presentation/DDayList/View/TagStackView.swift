//
//  TagStackView.swift
//  DayCount
//
//  Created by ChangMin on 2023/05/14.
//

import UIKit

import SnapKit


final class TagStackView: UIStackView {
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        initView()
    }
    
    // MARK: Methods
    
    private func initView() {
        setupBaseView()
      
    }
    
    private func setupBaseView() {
        axis = .horizontal
        distribution = .equalSpacing
        spacing = 8
    }
}
