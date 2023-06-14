//
//  DDayRespository.swift
//  DayCount
//
//  Created by ChangMin on 2023/04/07.
//

import CoreData
import Foundation

protocol DDayRepositoryProtocol {
    func fetchDDay() -> DDayList?
    func saveDDay(item: DDay)
    func removeDDay(item: DDay)
    
    func fetchTag() -> [Tag]?
}

final class DDayRepository: DDayRepositoryProtocol {

}

extension DDayRepository {
    func fetchDDay() -> DDayList? {
        let context = CoreDataManager.shared.managedObjectContext
            
        do {
            let dday = try context.fetch(DDayModel.fetchRequest()) as! [DDayModel]
            var list = DDayList()
            
            for model in dday {
                list.append(DDay(title: model.title!, date: model.date!, isSwitchOn: model.isSwitchOn))
            }
            
            return list
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func saveDDay(item: DDay) {
        let context = CoreDataManager.shared.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "DDayModel", in: context)
        
        if let entity = entity {
            let dday = NSManagedObject(entity: entity, insertInto: context)
            dday.setValue(item.title, forKey: "title")
            dday.setValue(item.date, forKey: "date")
            dday.setValue(item.isSwitchOn, forKey: "isSwitchOn")
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeDDay(item: DDay) {
        let context = CoreDataManager.shared.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DDayModel")
        let predicate = NSPredicate(format: "title == %@", item.title)
        request.predicate = predicate
        
        let result = try! CoreDataManager.shared.managedObjectContext.fetch(request)
        if let objectToDelete = result.first as? NSManagedObject {
            context.delete(objectToDelete)
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
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
}
