//
//  TagModel+CoreDataProperties.swift
//  DayCount
//
//  Created by ChangMin on 2023/07/02.
//
//

import Foundation
import CoreData


extension TagModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagModel> {
        return NSFetchRequest<TagModel>(entityName: "TagModel")
    }

    @NSManaged public var title: String?

}

extension TagModel : Identifiable {

}
