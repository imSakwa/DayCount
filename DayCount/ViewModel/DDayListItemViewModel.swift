//
//  DDayListItemViewModel.swift
//  DayCount
//
//  Created by ChangMin on 2023/01/15.
//

import Foundation

import RxCocoa
import RxSwift

final class DDayListItemViewModel: ViewModelType {
    struct Input {
        let titleStr: Driver<String>
        let dateStr: Driver<String>
        let isSwitchOn: Driver<Bool>
        let tapDone: ControlEvent<Void>
    }
    
    struct Output {
        let enableSaveButton: Driver<Bool>
        let tapDoneButton: Driver<(String,String,Bool)>
//        let ddaylist: Driver<[DDay]>
//        let goToMain = PublishRelay<Void>()
    }
    
    private let ddayList: [DDay] = [DDay]()
    
    func transform(input: Input) -> Output {
        let enableSaveButton = Driver
            .combineLatest(input.titleStr, input.dateStr)
            .map{ !$0.0.isEmpty && !$0.1.isEmpty }
            .asDriver(onErrorJustReturn: false)
    
        let tapDoneButton = input.tapDone
            .withLatestFrom(
                Driver.combineLatest(input.titleStr, input.dateStr, input.isSwitchOn)
            )
            .asDriver(onErrorJustReturn: ("","",false))
        
//            .bind { [weak self] (title, date, isSwitchOn) in
//                var date = date
//                if isSwitchOn {
//                    let format_date = DateFormatter()
//                    format_date.dateFormat = "yyyy-MM-dd"
//                    let currentDate = format_date.string(from: Date())
//                    let splitdate = currentDate.split(separator: "-")
//
//                    date = splitdate[0]+"년 "+splitdate[1]+"월 "+splitdate[2]+"일"
//                }
//                else {
//                    date = ""
//                }
//
//                let newDay = DDay(title: title, date: date, isSwitchOn: isSwitchOn)
//
//            }
//            .disposed(by: disposeBag)
        
        return Output(
            enableSaveButton: enableSaveButton,
            tapDoneButton: tapDoneButton
        )
    }
    
    
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
