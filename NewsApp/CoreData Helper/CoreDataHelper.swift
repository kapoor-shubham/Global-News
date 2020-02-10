//
//  CoreDataHelper.swift
//  NewsApp
//
//  Created by Shubham Kapoor on 05/02/20.
//  Copyright © 2020 Shubham Kapoor. All rights reserved.
//
//

import Foundation
import CoreData

typealias RetriveDataResponse = (_ resultObject: [NSManagedObject]?, _ error: Error?) -> Void
typealias CoreDataResponse = (_ success: Bool, _ error: Error?) -> Void

class CoreDataHelper {
    
    static let shared = CoreDataHelper()
    
    /**
     Retrive Data with predicate conditions

    - Parameter entityName: Core Data Entity Name.
    - Parameter predicate: Predicate Condition.
    - Parameter fetchCompletion: Completion Handler.
     **/
    func retrieveData(entityName: String, predicate: NSPredicate?, fetchCompletion: @escaping (RetriveDataResponse)) -> Void {

        let managedContext = CoreDataStack.shared.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false

        if let fetchPredicate = predicate {
            fetchRequest.predicate = fetchPredicate
        }
                
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let response = result as? [NSManagedObject] {
                fetchCompletion(response, nil)
            }
        } catch let error {
            fetchCompletion(nil, error)
        }
    }
    
    /**
     Saves Data in Core Data

    - Parameter entity: Core Data Entity Name.
    - Parameter data: Data to add in the particular entity.
    - Parameter completion: Completion Handler.
     **/
    func saveData(entity: String, data: [String: Any], completion: @escaping(CoreDataResponse)) -> Void {
        let managedContext = CoreDataStack.shared.context
        CoreDataStack.shared.context.perform {
            if let entity = NSEntityDescription.entity(forEntityName: entity, in: managedContext) {
                let managedObj = NSManagedObject(entity: entity, insertInto: managedContext)
                for (key, value) in data {
                    print("CoreData Key:- \(key) with Value:- \(value)")
                    managedObj.setValue(value, forKey: key)
                }
                do {
                    try managedContext.save()
                    print("Saved in CoreData")
                    completion(true, nil)
                } catch let error {
                    print("CoreData Error = \(error)")
                    completion(false, error)
                }
            }
        }
    }
    
    /**
     Deletes the Managed Objects.

    - Parameter managedObjects: Array of selected managed objects.
    - Parameter deleteCompletion: Completion Handler.
     **/
    func deleteManagedObjects(managedObjects: [NSManagedObject], deleteCompletion: @escaping (CoreDataResponse)) -> Void {

        let managedContext = CoreDataStack.shared.context
        
        if managedObjects.count > 0 {
            
            for item in managedObjects {
                managedContext.delete(item)
            }
            do {
                try managedContext.save()
                deleteCompletion(true, nil)
            } catch let error {
                deleteCompletion(false, error)
            }
        } else {
            deleteCompletion(false, nil)
        }
    }
    
    /**
     Deletes the Managed Objects of related entity

    - Parameter entity: Core Data Entity Name.
    - Parameter predicate: Predicate Condition.
    - Parameter data: Data to update or add in the particular entity.
    - Parameter updateCompletion: Completion Handler.
     **/
    func deleteData(entity: String, predicate: NSPredicate?, deleteCompletion: @escaping (CoreDataResponse)) -> Void {

        let managedContext = CoreDataStack.shared.context
        CoreDataStack.shared.context.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            fetchRequest.returnsObjectsAsFaults = false
            
            if let fetchPredicate = predicate {
                fetchRequest.predicate = fetchPredicate
            }
            
            do {
                let results = try managedContext.fetch(fetchRequest)
                for managedObject in results {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    managedContext.delete(managedObjectData)
                }
                deleteCompletion(true, nil)
            } catch let error {
                deleteCompletion(false, error)
            }
        }
    }
    
    /**
     Updates or Saves the value according to the predicate condition.

    - Parameter entity: Core Data Entity Name.
    - Parameter predicate: Predicate Condition.
    - Parameter data: Data to update or add in the particular entity.
    - Parameter updateCompletion: Completion Handler.
     **/
    func updateValue(entityName: String, predicate: NSPredicate?, data: [String: Any], updateCompletion: @escaping (CoreDataResponse)) -> Void {
        
        let managedContext = CoreDataStack.shared.context
        CoreDataStack.shared.context.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.returnsObjectsAsFaults = false
            
            if let fetchPredicate = predicate {
                fetchRequest.predicate = fetchPredicate
            }
            
            do {
                let result = try managedContext.fetch(fetchRequest)
                if let response = result as? [NSManagedObject] {
                    
                    if response.count == 0 {
                        self.saveData(entity: entityName, data: data) { (success, error) in
                            if let err = error {
                                updateCompletion(false, err)
                            } else {
                                updateCompletion(true, nil)
                            }
                        }
                    } else {
                        for (key, value) in data {
                            response.first?.setValue(value, forKey: key)
                        }
                        do {
                            try managedContext.save()
                            updateCompletion(true, nil)
                        } catch let error {
                            updateCompletion(false, error)
                        }
                    }
                }
            } catch let error {
                updateCompletion(false, error)
            }
        }
    }
    
    /**
     Get Saved Data.

    - Parameter entityName: Core Data Entity Name.
    - Parameter fetchCompletion: Completion Handler.
     **/
    func getSavedData(entityName: String, fetchCompletion: @escaping (RetriveDataResponse)) -> Void {
 
        let managedContext = CoreDataStack.shared.context
        CoreDataStack.shared.context.perform {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let result = try managedContext.fetch(fetchRequest)
                if let response = result as? [NSManagedObject] {
                    fetchCompletion(response, nil)
                }
            }
            catch let error {
                print("CoreData Error = \(error)")
                fetchCompletion(nil, error)
            }
            
        }
    }
    
    /**
     Update a particular Managed Object in CoreData.

    - Parameter entity: Core Data Entity Name.
    - Parameter predicate: Predicate Condition.
    - Parameter attributeKey: Attribute Key.
    - Parameter attributeValue: Attribute Value.
    - Parameter updateCompletion: Completion Handler.
     **/
    func updateKeyValue(entity: String, predicate: NSPredicate, attributeKey: String, attributeValue: String, updateCompletion: @escaping (CoreDataResponse)) -> Void {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.predicate = predicate
        let managedContext = CoreDataStack.shared.context
        do{
            if let fetchResults = try managedContext.fetch(request) as? [NSManagedObject] {
                if let resultToUpdate = fetchResults.first {
                    resultToUpdate.setValue(attributeValue, forKey: attributeKey)
                    try managedContext.save()
                    updateCompletion(true, nil)
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            updateCompletion(false, error)
        }
    }
}
