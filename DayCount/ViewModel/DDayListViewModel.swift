//
//  ItemViewModel.swift
//  DayCount
//
//  Created by 창민 on 2021/06/28.
//

import Foundation

import Combine
//import RxCocoa
//import RxSwift

final class DDayListViewModel: ViewModelType {
    struct Input {
//        let tapAddButton: ControlEvent<Void>
        let tapAddButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
//        let buttonTap: Driver<Void>
        let buttonTap: AnyPublisher<Void, Never>
    }
    
//    private var disposeBag = DisposeBag()
    private var subscriptions = Set<AnyCancellable>()
    var ddayList: [DDay] = []
    
    func transform(input: Input) -> Output {
        let buttonTap = input.tapAddButton
            .eraseToAnyPublisher()
//            .asDriver(onErrorJustReturn: ())
        
        return Output(buttonTap: buttonTap)
    }
}
