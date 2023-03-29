//
//  ItemViewModel.swift
//  DayCount
//
//  Created by 창민 on 2021/06/28.
//

import Combine
import Foundation

final class DDayListViewModel: ViewModelType {
    struct Input {
        let tapAddButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let buttonTap: AnyPublisher<Void, Never>
    }
    
    private var subscriptions = Set<AnyCancellable>()
    var ddayList: [DDay] = []
    
    func transform(input: Input) -> Output {
        let buttonTap = input.tapAddButton
            .eraseToAnyPublisher()
        
        return Output(buttonTap: buttonTap)
    }
}
