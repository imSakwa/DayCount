//
//  ItemViewModel.swift
//  DayCount
//
//  Created by 창민 on 2021/06/28.
//

import Combine
import CoreData
import Foundation

final class DDayListViewModel: ViewModelType {
    private var subscriptions = Set<AnyCancellable>()
    private var ddayList: DDayList = []
    private let ddayUseCase: DDayUseCaseProtocol
    
    init(useCase: DDayUseCaseProtocol) {
        ddayUseCase = useCase
        
        getDDayList()
    }
    
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
}

extension DDayListViewModel {
    /// Model에 데이터 추가
    func addDDayItem(item: DDay) {
        ddayList.append(item)
        
        ddayUseCase.addDDay(item: item)
    }
    
    private func getDDayList() {
        if let ddayList = ddayUseCase.getDDay() {
            self.ddayList = ddayList
        }
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
