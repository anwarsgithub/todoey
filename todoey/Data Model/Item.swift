//
//  Item.swift
//  todoey
//
//  Created by Anwar Numa on 8/17/19.
//  Copyright © 2019 Anwar Numa. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Categories.self, property: "items")
    
}
