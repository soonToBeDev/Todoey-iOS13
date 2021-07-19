//
//  Item.swift
//  Todoey
//
//  Created by Adham Hamed on 7/18/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
//Realm is used for single users, it stores all of the data locally on our device


class Item : Object{    //The Item data model is a REALM Object, by subclassing "Object" we are able to save our data as REALM
    
   @objc dynamic var title : String = ""
   @objc dynamic var done : Bool = false
   @objc dynamic var dateCreated : Date?
    
    // We have 3 dynamic properties in our Item data model, the title, whether if it was done or not (.checkmark) and the date a specific Item was created.
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    // parentCategory is the inverse relatinship that links each Item back to a parent Category for example if we have a Category called Home and inside that category we have an Item called stove, Home is the parent category of stove and in order to assign stove as its "child" we have to use LinkingObjects, with a type of "Category.self" to relate the Home Category and that stove to each other, and we give it a property name of the inverse relationship which is "items" -> ( let items = List<Item>() from Item.swift )
}
