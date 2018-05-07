//
//  LocationMapViewControllerTests.swift
//  LocationSearchTests
//
//  Created by Dinesh Selvaraj on 5/5/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import XCTest
import MapKit
@testable import LocationSearch

class LocationMapViewControllerTests: XCTestCase {
    
    var viewController: LocationMapViewController!
    var presenterMock: LocationMapPresenterMock!
    
    override func setUp() {
        super.setUp()
        viewController = LocationMapViewController.init(nibName: "LocationMapViewController", bundle: nil)
        presenterMock = LocationMapPresenterMock.init(viewController, entry: .locationResult)

    }
    
    func testDeleteRightBarButtonItem() {
        //Given
        presenterMock.islocationAvailableInDB = true
        viewController.presenter = presenterMock
        
        //When
        _ = viewController.view
        
        //Then
        XCTAssertEqual(viewController.navigationItem.rightBarButtonItem?.title, "Delete")
    }
    
    func testSaveRightBarButtonItem() {
        //Given
        presenterMock.islocationAvailableInDB = false
        viewController.presenter = presenterMock

        
        //When
        _ = viewController.view
        
        //Then
        XCTAssertEqual(viewController.navigationItem.rightBarButtonItem?.title, "Save")
    }
    
    func testSaveButtonSelected() {
        //Given
        let locationViewModel = LocationDetailViewModel(formattedAddress: "Test Address", lattitude: 12.123456, longitude: -23.123456, placeId: "TestPlaceID")
        presenterMock.centerLocation = locationViewModel
        viewController.presenter = presenterMock
        
        //When
        viewController.saveButtonSelected()
        
        //Then
        XCTAssertTrue(presenterMock.locationSaveCalled)
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem?.title == "Delete")
    }
    
    //TODO: - Dinesh
    /*
    func testMapCenterRegion() {
        //Given
        let locationViewModel = LocationDetailViewModel(formattedAddress: "Test Address", lattitude: 12.123456, longitude: -23.123456, placeId: "TestPlaceID")
        presenterMock.centerLocation = locationViewModel
        viewController.presenter = presenterMock
        
        //When
        _ = viewController.view
        
        //The
        XCTAssertTrue(viewController.mapView.region.center.latitude)
    }
 */
    
    override func tearDown() {
        viewController = nil
        presenterMock = nil
        super.tearDown()
    }
}
