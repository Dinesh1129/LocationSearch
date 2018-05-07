//
//  LocationDetail+CoreDataProperties.swift
//  LocationSearch
//
//  Created by Dinesh Selvaraj on 5/5/18.
//  Copyright © 2018 ABCD. All rights reserved.
//
//

import Foundation
import CoreData


extension LocationDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationDetail> {
        return NSFetchRequest<LocationDetail>(entityName: "LocationDetail")
    }

    @NSManaged public var placeId: String?
    @NSManaged public var formattedAddress: String?
    @NSManaged public var lattitude: Double
    @NSManaged public var longitude: Double

}
