//
//  Categories.swift
//  todoey
//
//  Created by Anwar Numa on 8/17/19.
//  Copyright © 2019 Anwar Numa. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Categories: Object{
    
    @objc dynamic var color = ""
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
