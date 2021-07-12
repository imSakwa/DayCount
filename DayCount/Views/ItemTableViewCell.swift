//
//  ItemView.swift
//  DayCount
//
//  Created by 창민 on 2021/05/21.
//

import RxCocoa
import RxSwift
import UIKit

class ItemTableViewCell: UITableViewCell {
        
    var itemStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemGray6
        stackView.layer.borderColor = UIColor.systemGray.cgColor
        stackView.layer.borderWidth = 3.0
        stackView.layer.cornerRadius = 15
        stackView.clipsToBounds = true
        return stackView
    }()
    
    var title: UILabel = {
        let titlelabel = UILabel()
        titlelabel.textColor = .black
        titlelabel.font = UIFont.systemFont(ofSize: 18)
        titlelabel.translatesAutoresizingMaskIntoConstraints = false
        return titlelabel
    }()
    
    var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var date: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var ddaylabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupView()
        setupLayout()
    }
    
    func setupView(){
        dateStackView.addArrangedSubview(date)
        dateStackView.addArrangedSubview(ddaylabel)
        
        itemStackView.addArrangedSubview(title)
        itemStackView.addArrangedSubview(dateStackView)
        
        contentView.addSubview(itemStackView)
    }
    
    func setupLayout(){
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-20).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/10).isActive = true

        itemStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        itemStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        itemStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        itemStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        
        title.leftAnchor.constraint(equalTo: itemStackView.leftAnchor, constant: 10).isActive = true
        title.rightAnchor.constraint(equalTo: dateStackView.leftAnchor, constant: 0).isActive = true
        
        dateStackView.topAnchor.constraint(equalTo: itemStackView.topAnchor).isActive = true
        dateStackView.bottomAnchor.constraint(equalTo: itemStackView.bottomAnchor).isActive = true
        dateStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        
        date.topAnchor.constraint(equalTo: itemStackView.topAnchor, constant: 10).isActive = true
        date.rightAnchor.constraint(equalTo: dateStackView.rightAnchor, constant: -10).isActive = true
        date.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/30).isActive = true
        
        ddaylabel.rightAnchor.constraint(equalTo: date.rightAnchor).isActive = true
        ddaylabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
    }
}

