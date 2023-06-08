//
//  TagRepository.swift
//  DayCount
//
//  Created by ChangMin on 2023/06/08.
//

import CoreData
import Foundation

protocol TagRepositoryProtocol {
    func fetchTag() -> [Tag]?
    func saveTag(tag: Tag)
}

final class TagRepository: TagRepositoryProtocol {
    func fetchTag() -> [Tag]? {
        let context = CoreDataManager.shared.managedObjectContext
            
        do {
            let tag = try context.fetch(TagModel.fetchRequest()) as! [TagModel]
            var tagList = TagList()

            for model in tag {
                tagList.append(Tag(title: model.title!))
            }
            
            return tagList
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func saveTag(tag: Tag) {
        let context = CoreDataManager.shared.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "TagModel", in: context)
        
        if let entity = entity {
            let tagObject = NSManagedObject(entity: entity, insertInto: context)
            tagObject.setValue(tag.title, forKey: "title")
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
