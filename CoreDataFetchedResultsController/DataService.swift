//
//  DataService.swift
//  CoreDataFetchedResultsController
//
//  Created by apple on 5/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import CoreData

class DataService {
    static let shared: DataService = DataService()
    
    private var _fetchedResultsController: NSFetchedResultsController<Entity>?
    var fetchedResultsController: NSFetchedResultsController<Entity> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        let fetchRequest: NSFetchRequest = Entity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.fetchBatchSize = 30
        fetchRequest.sortDescriptors = [sortDescriptor]
        _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.context, sectionNameKeyPath: nil, cacheName: "Master")
        do {
            try _fetchedResultsController?.performFetch()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
        return _fetchedResultsController!
    }
    func saveToCoreData() {
        guard let context = _fetchedResultsController?.managedObjectContext else { return  }
        do {
            try context.save()
            print("Core Data Saved")
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
