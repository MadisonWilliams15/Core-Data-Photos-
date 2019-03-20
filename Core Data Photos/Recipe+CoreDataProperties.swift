//
//  Recipe+CoreDataProperties.swift
//  Core Data Photos
//
//  Created by Madison Williams on 3/19/19.
//  Copyright © 2019 Madison Williams. All rights reserved.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var ingredients: String?
    @NSManaged public var directions: String?
    @NSManaged public var picture: NSData?
    @NSManaged public var title: String?

}
