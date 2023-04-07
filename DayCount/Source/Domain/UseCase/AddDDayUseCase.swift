//
//  AddDDayUseCase.swift
//  DayCount
//
//  Created by ChangMin on 2023/04/07.
//

import Foundation

protocol AddDDayUseCaseProtocol {
    func addDDay(item: DDay)
    func getDDay() -> DDayList?
}

final class AddDDayUseCase: AddDDayUseCaseProtocol {
    private let ddayRespository: DDayRepositoryProtocol
    
    init(respository: DDayRepositoryProtocol) {
        ddayRespository = respository
    }
}

extension AddDDayUseCase {
    func addDDay(item: DDay) {
        ddayRespository.saveDDay(item: item)
    }
    
    func getDDay() -> DDayList? {
        return ddayRespository.fetchDDay()
    }
}
