//
//  CoreDataManager.swift
//  RickAndMorty
//
//  Created by Mousa Alwaraki on 10/18/20.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    func fetchData(_ name: String, completion: @escaping ([NSManagedObject]) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
        
        do {
            let returnedArray = try managedContext.fetch(fetchRequest)
            completion(returnedArray)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
