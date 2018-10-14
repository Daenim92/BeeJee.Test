//
//  Contact+CoreDataClass.swift
//  
//
//  Created by Daenim on 10/14/18.
//
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let coreDataContext = CodingUserInfoKey(rawValue: "coreDataContext")!
}

@objc(Contact)
public class Contact: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case city
        case contactID
        case firstName
        case lastName
        case phoneNumber
        case state
        case streetAddress1
        case streetAddress2
        case zipcode
    }
    
    convenience init(context: NSManagedObjectContext) {
        self.init(entity: context.entity(for: type(of: self)), insertInto: nil)
        self.contactID = UUID().uuidString
    }
    
    public required convenience init(from: Decoder) throws {
        let context = from.userInfo[.coreDataContext] as! NSManagedObjectContext //add error when missing context
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)!
        self.init(entity: entity, insertInto: nil)
        
        let container = try from.container(keyedBy: CodingKeys.self)
        self.contactID = try container.decode(String.self, forKey: .contactID)
        self.city = try container.decode(String.self, forKey: .city)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.state = try container.decode(String.self, forKey: .state)
        self.streetAddress1 = try container.decode(String.self, forKey: .streetAddress1)
        self.streetAddress2 = try container.decode(String.self, forKey: .streetAddress2)
        self.zipcode = try container.decode(String.self, forKey: .zipcode)
    }
}
