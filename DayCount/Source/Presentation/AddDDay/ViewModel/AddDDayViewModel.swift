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
    private let ddayList: [DDay] = [DDay]()
    
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
    }
}

// MARK: - Methods

extension AddDDayViewModel {
    func transform(input: Input) -> Output {
        let titleSubject = CurrentValueSubject<String, Never>("")
        let dateSubject = CurrentValueSubject<String, Never>("")
        let isSwitchOnSubject = CurrentValueSubject<Bool, Never>(false)
        let ddaySubject = PassthroughSubject<DDay, Never>()
        
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
                let dday = DDay(title: titleSubject.value,
                                date: dateSubject.value,
                                isSwitchOn: isSwitchOnSubject.value)
                
                ddaySubject.send(dday)
            })
            .store(in: &cancellables)
        
        return Output(
            enableSaveButton: enableButton,
            ddayItem: ddaySubject.eraseToAnyPublisher()
//            tapDoneButton: tapDoneButton
        )
    }
}
