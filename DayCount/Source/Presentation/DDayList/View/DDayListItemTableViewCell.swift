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
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let dateInfoView: UIView = {
        return UIView(frame: .zero)
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let ddaylabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 30)
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
        let inputDate: Date = dateFormatter.date(from: date) ?? Date()
        
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
        contentView.addSubview(itemStackView)
        [dateLabel, ddaylabel].forEach { dateInfoView.addSubview($0) }
        [titleLabel, dateInfoView].forEach { itemStackView.addArrangedSubview($0) }
        
        itemStackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.trailing.equalTo(dateInfoView.snp.leading)
        }

        dateInfoView.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
        
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        ddaylabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom)
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
}
