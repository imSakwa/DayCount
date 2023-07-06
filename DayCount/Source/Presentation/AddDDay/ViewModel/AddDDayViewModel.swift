//
//  AddDDayViewModel.swift
//  DayCount
//
//  Created by ChangMin on 2023/01/15.
//

import Combine
import Foundation

final class AddDDayViewModel: ViewModelType {
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let ddayList: DDayList = DDayList()
    var tagList: TagList = []
    private let tagUsecase: TagUsecaseProtocol
    
    // MARK: Initializers
    
    init(usecase: TagUsecaseProtocol) {
        tagUsecase = usecase
    }
    
    // MARK: Input & Output
    
    struct Input {
        let titleStr: AnyPublisher<String, Never>
        let dateStr: AnyPublisher<String, Never>
        let isSwitchOn: AnyPublisher<Bool, Never>
        let tapDone: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let enableSaveButton: AnyPublisher<Bool, Never>
        let ddayItem: AnyPublisher<DDay, Never>
        let tagItem: AnyPublisher<TagList, Never>
    }
}

// MARK: - Methods

extension AddDDayViewModel {
    func transform(input: Input) -> Output {
        let titleSubject = CurrentValueSubject<String, Never>("")
        let dateSubject = CurrentValueSubject<String, Never>("")
        let isSwitchOnSubject = CurrentValueSubject<Bool, Never>(false)
        let ddaySubject = PassthroughSubject<DDay, Never>()
        let tagSubject = PassthroughSubject<TagList, Never>()
        
        input.titleStr
            .sink {
                titleSubject.send($0)
            }
            .store(in: &cancellables)
        
        input.dateStr
            .print("Date: ")
            .sink {
                dateSubject.send($0)
            }
            .store(in: &cancellables)
        
        input.isSwitchOn
            .sink {
                isSwitchOnSubject.send($0)
            }
            .store(in: &cancellables)
        
        let enableButtonCase1 = input.titleStr
            .combineLatest(input.dateStr)
            .map { !$0.0.isEmpty && !$0.1.isEmpty }
            .eraseToAnyPublisher()
        
        let enableButtonCase2 = input.titleStr
            .combineLatest(input.isSwitchOn)
            .map { !$0.0.isEmpty && $0.1 }
            .eraseToAnyPublisher()
        
        let enableButton = enableButtonCase1
            .merge(with: enableButtonCase2)
            .eraseToAnyPublisher()
        
        input.tapDone
            .sink(receiveValue: { _ in
                let dday = DDay(
                    title: titleSubject.value,
                    date: dateSubject.value,
                    isSwitchOn: isSwitchOnSubject.value,
                    tags: self.tagList
                )
                
                tagSubject.send(self.tagList)
                ddaySubject.send(dday)
            })
            .store(in: &cancellables)
        
        return Output(
            enableSaveButton: enableButton,
            ddayItem: ddaySubject.eraseToAnyPublisher(),
            tagItem: tagSubject.eraseToAnyPublisher()
        )
    }
    
    func addTag(tagList: TagList) {
        tagList.forEach { tag in
            tagUsecase.addTag(tag: tag)
        }
    }
}
