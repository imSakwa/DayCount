//
//  AlertActionType.swift
//  DayCount
//
//  Created by ChangMin on 2023/05/07.
//

import Foundation

enum AlertActionType: String {
    case filter = "필터"
    case more = "더보기"
    
    var titleArray: [String] {
        switch self {
        case .filter:
            return DDayType.allCases.map { $0.rawValue }
        case .more:
            return DDayListCellType.allCases.map { $0.rawValue }
        }
    }
}
