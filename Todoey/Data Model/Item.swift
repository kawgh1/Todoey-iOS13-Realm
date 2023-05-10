//
//  Item.swift
//  Todoey
//
//  Created by J on 5/10/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    // '@objc' and 'dynamic' modifiers must be added to all Realm objects that we want to be managed and updated in realm time
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?

    
    // defined inverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
