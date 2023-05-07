//
//  DateInfoView.swift
//  DayCount
//
//  Created by ChangMin on 2023/05/07.
//

import UIKit

import SnapKit

final class DateInfoView: UIView {
    // MARK: Properties
    
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
        setupSubviews()
        setupLayouts()
    }
    
    private func setupSubviews() {
        [dateLabel, ddaylabel]
            .forEach { addSubview($0) }
    }
    
    private func setupLayouts() {
        dateLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview().priority(.medium)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(self.snp.centerY)
        }
        
        ddaylabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.centerY)
            $0.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview().priority(.medium)
        }
    }
    
    func setupDateInfo(with dday: DDay) {
        dateLabel.text = dday.isSwitchOn ? dday.date + "~" : "~" + dday.date
        
        let day: String = String(calcDDay(date: dday.date, isSwitchOn: dday.isSwitchOn))
        ddaylabel.text = dday.isSwitchOn ? "D+" + day : "D-" + day
    }
    
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
}
