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
        
        return Output(
            enableSaveButton: enableSaveButton,
            tapDoneButton: tapDoneButton
        )
    }
}
