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
    private var cancellables = Set<AnyCancellable>()
    private var ddayList: DDayList = []
    private let ddayUseCase: DDayUseCaseProtocol
    
    init(useCase: DDayUseCaseProtocol) {
        ddayUseCase = useCase
    }
    
    struct Input {
        let tapAddButton: AnyPublisher<Void, Never>
        let tapFilterButton: AnyPublisher<String, Never>
        let tapMoreButton: AnyPublisher<String, Never>
    }
    
    struct Output {
        let buttonTap: AnyPublisher<Void, Never>
    }
    
    func transform(input: Input) -> Output {
        let buttonTap = input.tapAddButton
            .eraseToAnyPublisher()
        
        input.tapFilterButton
            .sink { value in
                print(value)
            }
            .store(in: &cancellables)
        
        input.tapMoreButton
            .sink { value in
                print(value)
            }
            .store(in: &cancellables)
        
        return Output(buttonTap: buttonTap)
    }
}

extension DDayListViewModel {
    
    func addDDayItem(item: DDay) {
        ddayList.append(item)
        
        ddayUseCase.addDDay(item: item)
    }
    
    func removeDDayItem(row: Int) {
        ddayUseCase.removeDDay(item: ddayList[row])
        let _ = ddayList.remove(at: row)
    }
    
    func fetchDDayList() {
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
    
    func getDDayList() -> DDayList {
        return ddayList
    }
    
    func getDDayArrayCount() -> Int {
        return ddayList.count
    }
    
    func getActionTitleArray(type: AlertActionType) -> [String] {
        return type.titleArray
    }
}
