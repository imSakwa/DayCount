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
}
