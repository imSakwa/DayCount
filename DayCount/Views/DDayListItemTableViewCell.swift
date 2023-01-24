//
//  ItemView.swift
//  DayCount
//
//  Created by 창민 on 2021/05/21.
//

import UIKit

import RxCocoa
import RxSwift

final class DDayListItemTableViewCell: UITableViewCell {
    static let identifier = String(describing: DDayListItemTableViewCell.self)
    
    private let viewModel = DDayListItemViewModel()
        
    private lazy var itemStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ddaylabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        translatesAutoresizingMaskIntoConstraints = false
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension DDayListItemTableViewCell {
    func bind(data: DDay) {
        titleLabel.text = data.title
        
        if data.isSwitchOn {
            dateLabel.text = data.date + "~"
            let dday: String = String(viewModel.calcDDay(date: data.date, isSwitchOn: data.isSwitchOn))
            ddaylabel.text = "D+"+dday
        } else {
            dateLabel.text = "~" + data.date
            let dday: String = String(viewModel.calcDDay(date: data.date, isSwitchOn: data.isSwitchOn))
            ddaylabel.text = "D-"+dday
        }
    }
    
    private func setupView(){
        [dateLabel, ddaylabel].forEach { dateStackView.addArrangedSubview($0) }
        [titleLabel, dateStackView].forEach { itemStackView.addArrangedSubview($0) }
        
        contentView.addSubview(itemStackView)
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.width-20
            ),
            contentView.heightAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.height/10
            )
        ])
        
        NSLayoutConstraint.activate([
            itemStackView.leftAnchor.constraint(
                equalTo: contentView.leftAnchor
            ),
            itemStackView.rightAnchor.constraint(
                equalTo: contentView.rightAnchor
            ),
            itemStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            itemStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -5
            )
        ])

        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(
                equalTo: itemStackView.leftAnchor,
                constant: 10
            ),
            titleLabel.rightAnchor.constraint(
                equalTo: dateStackView.leftAnchor
            )
        ])
        
        NSLayoutConstraint.activate([
            dateStackView.topAnchor.constraint(
                equalTo: itemStackView.topAnchor
            ),
            dateStackView.bottomAnchor.constraint(
                equalTo: itemStackView.bottomAnchor
            ),
            dateStackView.rightAnchor.constraint(
                equalTo: contentView.rightAnchor,
                constant: -10
            )
        ])
      
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(
                equalTo: itemStackView.topAnchor,
                constant: 10
            ),
            dateLabel.rightAnchor.constraint(
                equalTo: dateStackView.rightAnchor,
                constant: -10
            ),
            dateLabel.heightAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.height/30
            )
        ])
      
        NSLayoutConstraint.activate([
            ddaylabel.rightAnchor.constraint(
                equalTo: dateLabel.rightAnchor
            ),
            ddaylabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10
            )
        ])
    }
}