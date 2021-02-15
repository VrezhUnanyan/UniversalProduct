//
//  Product+CoreDataProperties.swift
//  UniversalProduct
//
//  Created by Vrezh on 12/22/20.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var count: Int32
    @NSManaged public var image: Data?
    @NSManaged public var minorDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Int32

}

extension Product : Identifiable {

}
