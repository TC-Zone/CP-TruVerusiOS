//
//  User+CoreDataProperties.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 3/28/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var profileimageurl: String?
    @NSManaged public var email: String?
    @NSManaged public var name: String?

}
