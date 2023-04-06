//
//  AddDDayViewModel.swift
//  DayCount
//
//  Created by ChangMin on 2023/01/15.
//

import Combine
import Foundation

final class AddDDayViewModel: ViewModelType {
    struct Input {
        let titleStr: AnyPublisher<String, Never>
        let dateStr: AnyPublisher<String, Never>
        let isSwitchOn: AnyPublisher<Bool, Never>
        let tapDone: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let enableSaveButton: AnyPublisher<Bool, Never>
        let tapDoneButton: AnyPublisher<(Void, String, String, Bool), Never>
    }
    
    var cancel = Set<AnyCancellable>()
    private let ddayList: [DDay] = [DDay]()
    
    func transform(input: Input) -> Output {
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
        
        let tapDoneButton = input.tapDone
            .zip(input.titleStr, input.dateStr, input.isSwitchOn)
            .eraseToAnyPublisher()
        
        return Output(
            enableSaveButton: enableButton,
            tapDoneButton: tapDoneButton
        )
    }
}
