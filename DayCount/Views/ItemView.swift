//
//  ItemView.swift
//  DayCount
//
//  Created by 창민 on 2021/05/21.
//

import UIKit

class ItemView: UIView {
        
    var itemStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .systemGray6
        stackView.layer.borderColor = UIColor.systemGray.cgColor
        stackView.layer.borderWidth = 3.0
        stackView.layer.cornerRadius = 15
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        itemStackView.addArrangedSubview(title)
        itemStackView.addArrangedSubview(dateStackView)
        
        dateStackView.addArrangedSubview(date)
        dateStackView.addArrangedSubview(ddaylabel)
        
        addSubview(itemStackView)
        
        setLayout()
    }
    
    // dday 계산 알고리즘
    func calcDDay(date: String, isSwitchOn: Bool) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") as TimeZone?
        let todayDate: Date = dateFormatter.date(from: dateFormatter.string(from: Date()))!
        let textFieldDate: Date = dateFormatter.date(from: date)!
        
        var interval: TimeInterval
        if isSwitchOn {
            interval = todayDate.timeIntervalSince(textFieldDate)
        } else {
            interval = textFieldDate.timeIntervalSince(todayDate)
        }
        return Int(interval/86400)
    }
    
    func setLayout(){
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-20).isActive = true
        self.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/10).isActive = true
        
        itemStackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        itemStackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        itemStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        itemStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        itemStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        title.leftAnchor.constraint(equalTo: itemStackView.leftAnchor, constant: 10).isActive = true
        
        dateStackView.topAnchor.constraint(equalTo: itemStackView.topAnchor).isActive = true
        dateStackView.bottomAnchor.constraint(equalTo: itemStackView.bottomAnchor).isActive = true
        dateStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        date.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        date.rightAnchor.constraint(equalTo: dateStackView.rightAnchor, constant: -10).isActive = true
        date.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/30).isActive = true
        
        ddaylabel.rightAnchor.constraint(equalTo: date.rightAnchor).isActive = true
        ddaylabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
    }
}

