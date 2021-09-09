//
//  Item.swift
//  Parsley
//
//  Created by Layne Johnson on 9/9/21.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
    @Persisted var dateCreated: Date?
    
    // Define an inverse relationship.
    @Persisted(originProperty:"items") var assignee: LinkingObjects<Category>
}
