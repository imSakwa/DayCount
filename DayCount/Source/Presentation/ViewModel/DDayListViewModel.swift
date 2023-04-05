//
//  ItemViewModel.swift
//  DayCount
//
//  Created by 창민 on 2021/06/28.
//

import Combine
import Foundation

final class DDayListViewModel: ViewModelType {
    private var subscriptions = Set<AnyCancellable>()
    private var ddayList: [DDay] = []
    
    struct Input {
        let tapAddButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let buttonTap: AnyPublisher<Void, Never>
    }
    
    func transform(input: Input) -> Output {
        let buttonTap = input.tapAddButton
            .eraseToAnyPublisher()
        
        return Output(buttonTap: buttonTap)
    }
    
    
    func addDDayItem(item: DDay) {
        ddayList.append(item)
    }
    
    func initDDayArray(array: [DDay]) {
        ddayList = array
    }
    
    func getDDayItem(row: Int) -> DDay {
        return ddayList[row]
    }
    
    func getDDayArrayCount() -> Int {
        return ddayList.count
    }
}
