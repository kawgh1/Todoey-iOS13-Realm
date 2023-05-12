//
//  Category.swift
//  Todoey
//
//  Created by J on 5/10/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    // '@objc' and 'dynamic' modifiers must be added to all Realm objects that we want to be managed and updated in realm time
    
    @objc dynamic var name: String = ""
    @objc dynamic var backgroundColor: String = ""
    
    // List is a Realm class
    // define relationship -- one to many
    let items = List<Item>()
    
    
}
