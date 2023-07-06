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
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private var ddayList: DDayList = []
    private var tagList: TagList = []
    private let ddayUseCase: DDayUseCaseProtocol
    
    // MARK: Initializers
    
    init(useCase: DDayUseCaseProtocol) {
        ddayUseCase = useCase
    }
    
    // MARK: Input & Output
    
    struct Input {
    }
    
    struct Output {
    }
}

// MARK: - Methods

extension DDayListViewModel {
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
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
    
    func fetchTagList() {
        if let tagList = ddayUseCase.fetchTagList() {
            self.tagList = tagList
        }
    }
    
    func initDDayArray(array: [DDay]) {
        ddayList = array
    }
        
    func getDDayList() -> DDayList {
        return ddayList
    }
    
    func getFilteredDDayList(with tag: String) -> DDayList {
        fetchDDayList()
        
        return ddayList.filter { $0.tags.contains(where: { $0.title == tag }) }
    }
    
    func getTagList() -> TagList {
        return tagList
    }
    
    func getDDayArrayCount() -> Int {
        return ddayList.count
    }
}
