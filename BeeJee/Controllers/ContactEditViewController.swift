//
//  ViewController.swift
//  BeeJee
//
//  Created by Daenim on 10/14/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import CoreData

class ContactEditViewController: UITableViewController {

    var editContact: Contact? { didSet { render() }}
    
    @IBAction func save() {
        guard let c = editContact
            else { return }
        
        c.city = cityField?.text
        c.firstName = firstNameField?.text
        c.lastName = lastNameField?.text
        c.phoneNumber = phoneNumberField?.text
        c.state = stateField?.text
        c.streetAddress1 = streetAddress1Field?.text
        c.streetAddress2 = streetAddress2Field?.text
        c.zipcode = zipcodeField?.text
        
        if c.managedObjectContext == nil {
            CoreDataManager.shared.context.insert(c)
        }
        CoreDataManager.shared.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var cityField: UITextField?
    @IBOutlet weak var firstNameField: UITextField?
    @IBOutlet weak var lastNameField: UITextField?
    @IBOutlet weak var phoneNumberField: UITextField?
    @IBOutlet weak var stateField: UITextField?
    @IBOutlet weak var streetAddress1Field: UITextField?
    @IBOutlet weak var streetAddress2Field: UITextField?
    @IBOutlet weak var zipcodeField: UITextField?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        render()
    }
    
    func render() {
        cityField?.text = editContact?.city
        firstNameField?.text = editContact?.firstName
        lastNameField?.text = editContact?.lastName
        phoneNumberField?.text = editContact?.phoneNumber
        stateField?.text = editContact?.state
        streetAddress2Field?.text = editContact?.streetAddress2
        streetAddress1Field?.text = editContact?.streetAddress1
        zipcodeField?.text = editContact?.zipcode
    }
}

