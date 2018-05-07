//
//  LocationStoreManagerTests.swift
//  LocationSearchTests
//
//  Created by Dinesh Selvaraj on 5/6/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import XCTest
import CoreData
@testable import LocationSearch

class LocationStoreManagerTests: XCTestCase {
    
    var locationStoreManager: LocationStorageManager!
    
    override func setUp() {
        super.setUp()
        initStubs()
        locationStoreManager = LocationStorageManager.init(mockPersistentContainer)
        
    }
    
    override func tearDown() {
        flushData()
        super.tearDown()
    }
    
    /*
    func testCreateLocationItem() {
        //Given
        let locationViewModel = LocationDetailViewModel(formattedAddress: "Address Test 1", lattitude: 12.092322, longitude: 32.254632, placeId: "PlaceIdTest1")
        
        //When
        let locationItem = locationStoreManager.insertLocationItem(locationViewModel)
        
        //Then
        XCTAssertNotNil(locationItem)
    }
 
    
    func testFetchAllLocationItems() {
        //When
        let results = locationStoreManager.fetchAllLocations()
        
        //Then
        XCTAssertEqual(results.count, 3)
    }
  */
    
    
    //MARK: - Mock Data Store
    lazy var mockPersistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "LocationSearch", managedObjectModel: self.managedObjetModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = true
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores {(description, error) in
            
            //Check if the data store is in memory
            precondition(description.type == NSInMemoryStoreType)
            
            //Check if creating container wrong
            if let error = error {
                fatalError("Create an in-memory coordinator failed\(error)")
            }
        }
        
        return container
    }()
    
    lazy var managedObjetModel: NSManagedObjectModel = {
        let managedObjectModel =  NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    func initStubs() {
        
        @discardableResult
        func insertLocationItem(_ placeId: NSString, formattedAddress: NSString, latitude: Double, longitude:Double) -> LocationDetail? {
            let obj = NSEntityDescription.insertNewObject(forEntityName: "LocationDetail", into: mockPersistentContainer.viewContext)
            obj.setValue(placeId, forKey: "placeId")
            obj.setValue(formattedAddress, forKey: "formattedAddress")
            obj.setValue(latitude, forKey: "lattitude")
            obj.setValue(longitude, forKey: "longitude")
            
            return obj as? LocationDetail
        }
        
        insertLocationItem("PlaceId1", formattedAddress: "Address 1", latitude: 12.1234, longitude: 13.1234)
        insertLocationItem("PlaceId2", formattedAddress: "Address 2", latitude: 22.1234, longitude: 23.1234)
        insertLocationItem("PlaceId3", formattedAddress: "Address 3", latitude: 32.1234, longitude: 33.1234)
        
        do {
            try mockPersistentContainer.viewContext.save()
        } catch {
            print("create fakes error \(error)")
        }
    }
    
    func flushData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationDetail")
        let objs = try! mockPersistentContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistentContainer.viewContext.delete(obj)
        }
        try! mockPersistentContainer.viewContext.save()
    }
    
}
