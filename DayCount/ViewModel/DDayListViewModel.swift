//
//  ItemViewModel.swift
//  DayCount
//
//  Created by 창민 on 2021/06/28.
//

import Foundation

import RxCocoa
import RxSwift

final class DDayListViewModel: ViewModelType {
    struct Input {
        let tapAddButton: ControlEvent<Void>
    }
    
    struct Output {
        let buttonTap: Driver<Void>
    }
    
    private var disposeBag = DisposeBag()
    var ddayList: [DDay] = []
    
    func transform(input: Input) -> Output {
        let buttonTap = input.tapAddButton
            .asDriver(onErrorJustReturn: ())
        
        return Output(buttonTap: buttonTap)
    }
}
