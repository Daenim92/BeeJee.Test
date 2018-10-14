//
//  ContactsTableViewController.swift
//  BeeJee
//
//  Created by Daenim on 10/14/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import CoreData

protocol ContactsList {
    var changeDelegate: NSFetchedResultsControllerDelegate? { get set }
    
    func create() -> Contact
    func retrieve() -> [NSFetchedResultsSectionInfo]?
    func update(_: Contact)
    func delete(_: Contact)
}

class ContactsTableViewController: UITableViewController {
    
    lazy var context: NSManagedObjectContext = CoreDataManager.shared.context
    lazy var resultsController: NSFetchedResultsController<Contact> = {
        let r: NSFetchRequest = Contact.fetchRequest()
        r.sortDescriptors = [NSSortDescriptor(key: Contact.CodingKeys.firstName.stringValue, ascending: true)]
        let c = NSFetchedResultsController(fetchRequest: r,
                                           managedObjectContext: context,
                                           sectionNameKeyPath: nil,
                                           cacheName: nil)
        
        c.delegate = self
        try! c.performFetch()
        return c
    }()

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return resultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.defaultContactCell.identifier, for: indexPath) 
        
        if let contact = resultsController.sections?[indexPath.section].objects?[indexPath.row] as? Contact {
            cell.textLabel?.text = contact.firstName
            cell.detailTextLabel?.text = contact.phoneNumber
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let c = resultsController.sections?[indexPath.section].objects?[indexPath.row] as? Contact
            else { return nil }
        return [
            UITableViewRowAction(style: .normal, title: "Edit", handler: { _,_  in
                self.performSegue(withIdentifier: "edit", sender: c)
            }),
            UITableViewRowAction(style: .destructive, title: "Delete", handler: { _,_  in
                c.managedObjectContext?.delete(c)
            })
        ]
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination, sender) {
        case (R.segue.contactsTableViewController.add.identifier?, let vc as ContactEditViewController, _):
            vc.editContact = Contact(context: context)
        case (R.segue.contactsTableViewController.edit.identifier?, let vc as ContactEditViewController, let contact as Contact):
            vc.editContact = contact
        default:
            NSLog("Unhandled segue: \(segue, sender)")
        }
    }

}

extension ContactsTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch (type, indexPath, newIndexPath) {
        case let (.insert, _, .some(index)):
            tableView.insertRows(at: [index], with: .automatic)
            
        case let (.delete, .some(index), _):
            tableView.deleteRows(at: [index], with: .automatic)
            
        case let (.move, .some(start), .some(end)):
            tableView.moveRow(at: start, to: end)
            
        case let (.update, .some(index), _):
            tableView.reloadRows(at: [index], with: .automatic)
            
        default:
            NSLog("Unhandled contact list update: \(self, controller, anObject, type, indexPath, newIndexPath)")
            tableView.reloadData()
        }
    }
}
