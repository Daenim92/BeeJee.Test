//
//  CoreData+Sugar.swift
//  BeeJee
//
//  Created by Daenim on 10/14/18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func entity(for type: NSManagedObject.Type) -> NSEntityDescription {
        let ed = NSEntityDescription.entity(forEntityName: String(describing: type), in: self)
        
        return ed!
    }
}

extension NSManagedObjectContext {
    func create<T: NSManagedObject>(_ type: T.Type, inserted: Bool = false) -> T? {        
        return T(entity: entity(for: type), insertInto: inserted ? self : nil)
    }
}
