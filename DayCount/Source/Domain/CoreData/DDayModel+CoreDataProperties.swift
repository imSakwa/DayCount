//
//  DDayModel+CoreDataProperties.swift
//  DayCount
//
//  Created by ChangMin on 2023/07/02.
//
//

import Foundation
import CoreData


extension DDayModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DDayModel> {
        return NSFetchRequest<DDayModel>(entityName: "DDayModel")
    }

    @NSManaged public var date: String?
    @NSManaged public var isSwitchOn: Bool
    @NSManaged public var tags: [String]
    @NSManaged public var title: String?

}

extension DDayModel : Identifiable {

}
