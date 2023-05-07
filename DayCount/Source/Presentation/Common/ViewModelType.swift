//
//  ViewModelType.swift
//  DayCount
//
//  Created by ChangMin on 2023/01/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
