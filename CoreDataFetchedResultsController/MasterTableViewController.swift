//
//  MasterTableViewController.swift
//  CoreDataFetchedResultsController
//
//  Created by apple on 5/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import CoreData

class MasterTableViewController: UITableViewController,NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController = DataService.shared.fetchedResultsController
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections![section].numberOfObjects
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let entity = fetchedResultsController.object(at: indexPath)
        configureCell(cell, with: entity)
        return cell
    }
    func configureCell(_ cell: UITableViewCell, with entity: Entity) {
        cell.textLabel?.text = entity.name
        cell.detailTextLabel?.text = String(entity.age)
        cell.imageView?.image = entity.photoImage as? UIImage
    }
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            do {
                try context.save()
            } catch let error as NSError {
                print("Save Error \(error), \(error.userInfo)")
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)!, with: anObject as! Entity)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)!, with: anObject as! Entity)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detaiViewController = segue.destination as? DetailViewController else { return }
        guard let index = tableView.indexPathForSelectedRow else { return }
        let object = fetchedResultsController.object(at: index)
        detaiViewController.detailObject = object
    }
    @IBAction func unwindFrom(for unwindSegue: UIStoryboardSegue) {
    
    }
}
