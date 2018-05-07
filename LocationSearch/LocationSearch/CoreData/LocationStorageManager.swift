//
//  CoreDataUtility.swift
//  LocationSearch
//
//  Created by Dinesh Selvaraj on 5/5/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import CoreData
import UIKit

class LocationStorageManager {
    
    let persistentContainer: NSPersistentContainer!
    
    init(_ container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        //Production env
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared application delegate")
        }
        self.init(appDelegate.persistentContainer)
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    @discardableResult
    func insertLocationItem(_ locationViewModel: LocationDetailViewModel) -> LocationDetail? {
        
        guard let location = NSEntityDescription.insertNewObject(forEntityName: "LocationDetail", into: backgroundContext) as? LocationDetail else {return nil}
        
        location.placeId = locationViewModel.placeId
        location.formattedAddress = locationViewModel.formattedAddress
        location.lattitude = locationViewModel.lattitude
        location.longitude = locationViewModel.longitude
        
        return location
    }
    
    func fetchAllLocations() -> [LocationDetail] {
        let fetchRequest: NSFetchRequest<LocationDetail> = LocationDetail.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(fetchRequest)
        return results ?? [LocationDetail]()
    }
    
    func deleteLocationItem(_ locationObjectID: NSManagedObjectID) {
        let obj = backgroundContext.object(with: locationObjectID)
        backgroundContext.delete(obj)
    }
    
    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save Location Error \(error)")
            }
        }
    }
}
