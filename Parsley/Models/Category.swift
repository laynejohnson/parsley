//
//  Category.swift
//  Parsley
//
//  Created by Layne Johnson on 9/9/21.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @Persisted var name: String = ""
    
    // Define a to-many relationship. 
    @Persisted var items: List<Item>
}
