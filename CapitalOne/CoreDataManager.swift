//
//  CoreDataManager.swift
//  CapitalOne
//
//  Created by Chase McCarty on 2015-08-23.
//  Copyright (c) 2015 Chase McCarty. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let managedContext = appDelegate.managedObjectContext!

//Give a username and password this saves a user in coreData
//App should only have one user shared at a time. so it tries to modify any existing entry
//before creating a new one.
func savePlayer(username: String, password: String) {
    var userToEdit = getSavedPlayer() as? User
    let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedContext)
    if userToEdit == nil{
        userToEdit = User(entity: entity!, insertIntoManagedObjectContext: managedContext)
    }
    
    userToEdit!.username = username
    userToEdit!.password = password
    
    var error: NSError?
    if !managedContext.save(&error){
        println("Error save: \(error?.userInfo)")
    }
    
}

//Retrieve a single instance of User.
//If it comes across more than one intance, it deletes all the others.
func getSavedPlayer() -> NSManagedObject? {
    var users = [NSManagedObject]()
    
    let fetchRequest = NSFetchRequest(entityName: "User")
    users = managedContext.executeFetchRequest(fetchRequest, error: nil) as! [User]
    
    if users.count == 0 {
        return nil
    } else if users.count == 1 {
        return users[0]
    } else {
        for index in 1...users.count-1 {
            managedContext.deleteObject(users[index])
        }
        return users[0]
    }
    
}

//Delete all saved users in coreData
func deletePlayers() {
    var users = [NSManagedObject]()
    let fetchRequest = NSFetchRequest(entityName: "User")
    users = managedContext.executeFetchRequest(fetchRequest, error: nil) as! [User]
    
    for user in users {
        managedContext.deleteObject(user)
    }
    
    var error: NSError?
    if !managedContext.save(&error) {
        println("Could not delete players \(error?.userInfo)")
    }
}
