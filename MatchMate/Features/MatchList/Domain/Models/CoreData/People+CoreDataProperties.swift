//
//  People+CoreDataProperties.swift
//  MatchMate
//
//  Created by Mihir Chauhan on 03/04/25.
//
//

import Foundation
import CoreData


extension People {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<People> {
        return NSFetchRequest<People>(entityName: "People")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var email: String?
    @NSManaged public var id: String?
    @NSManaged public var imageLarge: String?
    @NSManaged public var imageMedium: String?
    @NSManaged public var imageThumbnail: String?
    @NSManaged public var favouriteStatus: Int16
    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var country: String?

}

extension People : Identifiable {

}
