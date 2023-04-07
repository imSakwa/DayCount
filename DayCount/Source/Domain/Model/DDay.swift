//
//  DDay.swift
//  DayCount
//
//  Created by 창민 on 2021/05/21.
//

import Foundation
import CoreData

struct DDay: Codable {
    var title: String
    var date: String
    var isSwitchOn: Bool
    
    init(title: String, date: String, isSwitchOn: Bool){
        self.title = title
        self.date = date
        self.isSwitchOn = isSwitchOn
    }
}

typealias DDayList = [DDay]
