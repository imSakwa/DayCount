//
//  DDay.swift
//  DayCount
//
//  Created by 창민 on 2021/05/21.
//

import Foundation
import CoreData

struct DDay: Codable, Hashable {
    var title: String
    var date: String
    var isSwitchOn: Bool
    var tags: [Tag]
    
    init(title: String, date: String, isSwitchOn: Bool, tags: [Tag]) {
        self.title = title
        self.date = date
        self.isSwitchOn = isSwitchOn
        self.tags = tags
    }
}

typealias DDayList = [DDay]
