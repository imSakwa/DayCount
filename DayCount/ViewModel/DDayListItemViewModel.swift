//
//  DDayListItemViewModel.swift
//  DayCount
//
//  Created by ChangMin on 2023/01/15.
//

import Foundation

final class DDayListItemViewModel {
    // dday 계산 메서드
    func calcDDay(date: String, isSwitchOn: Bool) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") as TimeZone?
        
        let todayDate: Date = dateFormatter.date(from: dateFormatter.string(from: Date()))!
        let textFieldDate: Date = dateFormatter.date(from: date)!
        
        let aCase = todayDate.timeIntervalSince(textFieldDate)
        let bCase = textFieldDate.timeIntervalSince(todayDate)
        let interval: TimeInterval = isSwitchOn ? aCase : bCase
        
        return Int(interval/86400)
    }
}
