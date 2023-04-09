//
//  DDayUseCase.swift
//  DayCount
//
//  Created by ChangMin on 2023/04/07.
//

import Foundation

protocol DDayUseCaseProtocol {
    func addDDay(item: DDay)
    func getDDay() -> DDayList?
    func removeDDay(item: DDay)
}

final class DDayUseCase: DDayUseCaseProtocol {
    private let ddayRespository: DDayRepositoryProtocol
    
    init(respository: DDayRepositoryProtocol) {
        ddayRespository = respository
    }
}

extension DDayUseCase {
    func addDDay(item: DDay) {
        ddayRespository.saveDDay(item: item)
    }
    
    func getDDay() -> DDayList? {
        return ddayRespository.fetchDDay()
    }
    
    func removeDDay(item: DDay) {
        ddayRespository.removeDDay(item: item)
    }
}
