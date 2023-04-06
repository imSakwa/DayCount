//
//  ItemView.swift
//  DayCount
//
//  Created by 창민 on 2021/05/21.
//

import UIKit

import SnapKit


final class DDayListItemTableViewCell: UITableViewCell {
    static let identifier = String(describing: DDayListItemTableViewCell.self)
        
    private let itemStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .systemGray6
        stackView.layer.borderColor = UIColor.systemGray.cgColor
        stackView.layer.borderWidth = 3.0
        stackView.layer.cornerRadius = 15
        stackView.clipsToBounds = true
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let dateStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let ddaylabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension DDayListItemTableViewCell {
    private func calcDDay(date: String, isSwitchOn: Bool) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        
        let todayDate: Date = dateFormatter.date(from: dateFormatter.string(from: Date()))!
        let inputDate: Date = dateFormatter.date(from: date)!
        
        let aCase = todayDate.timeIntervalSince(inputDate)
        let bCase = inputDate.timeIntervalSince(todayDate)
        let ddayValue: Int = isSwitchOn ? abs(Int(aCase/86400)) + 1 : abs(Int(bCase/86400))
        
        return ddayValue
    }
    
    func setupView(data: DDay) {
        titleLabel.text = data.title
        
        if data.isSwitchOn {
            dateLabel.text = data.date + "~"
            let dday: String = String(calcDDay(date: data.date, isSwitchOn: data.isSwitchOn))
            ddaylabel.text = "D+"+dday
        } else {
            dateLabel.text = "~" + data.date
            let dday: String = String(calcDDay(date: data.date, isSwitchOn: data.isSwitchOn))
            ddaylabel.text = "D-"+dday
        }
    }
    
    private func setupLayout(){
        [dateLabel, ddaylabel].forEach { dateStackView.addArrangedSubview($0) }
        [titleLabel, dateStackView].forEach { itemStackView.addArrangedSubview($0) }
        
        contentView.addSubview(itemStackView)
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview().inset(20)
            $0.height.equalToSuperview().dividedBy(10)
        }
        
        itemStackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(5)
            
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(itemStackView.snp.leading).offset(10)
            $0.trailing.equalTo(dateStackView.snp.leading)
        }

        dateStackView.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(itemStackView).inset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(UIScreen.main.bounds.height).dividedBy(30)
        }
        
        ddaylabel.snp.makeConstraints {
            $0.trailing.equalTo(dateLabel)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
}
