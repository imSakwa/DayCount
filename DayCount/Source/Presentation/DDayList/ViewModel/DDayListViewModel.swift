//
//  ItemViewModel.swift
//  DayCount
//
//  Created by 창민 on 2021/06/28.
//

import Combine
import CoreData
import Foundation

enum ActionType: String {
    case filter = "필터"
    case more = "더보기"
}

final class DDayListViewModel: ViewModelType {
    private var cancellables = Set<AnyCancellable>()
    private var ddayList: DDayList = []
    private let ddayUseCase: DDayUseCaseProtocol
    
    let moreTitleArray = [
        "리스트",
        "정사각형"
    ]
    
    let filterTitleArray = [
        "기념일",
        "생일",
        "여행계획"
    ]
    
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
    /// Model에 데이터 추가
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
    
    
    /// 액션에 따른 타이틀 담긴 배열 반환
    /// - Parameter type: 액션의 타입
    /// - Returns: 액션 타이틀 배열
    func getActionTitleArray(type: ActionType) -> [String] {
        switch type {
        case .filter:
            return filterTitleArray
        case .more:
            return moreTitleArray
        }
    }
}
