//
//  User.swift
//  CapitalOne
//
//  Created by Chase McCarty on 2015-08-23.
//  Copyright (c) 2015 Chase McCarty. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var password: String
    @NSManaged var username: String

}
