//
//  Tag.swift
//  DayCount
//
//  Created by ChangMin on 2023/05/15.
//

import Foundation
import CoreData

struct Tag: Hashable, Codable {
    var title: String
    
    init(title: String) {
        self.title = title
    }
}

typealias TagList = [Tag]
