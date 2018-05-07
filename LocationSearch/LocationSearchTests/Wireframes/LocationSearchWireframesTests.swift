//
//  LocationSearchWireframesTests.swift
//  LocationSearchTests
//
//  Created by Dinesh Selvaraj on 5/6/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import XCTest
@testable import LocationSearch

class LocationSearchWireframesTests: XCTestCase {
    
    var wireframes: LocationSearchWireframe!
    
    override func setUp() {
        super.setUp()
        wireframes = LocationSearchWireframe.init()
    }
    
    func testDisplayLocationSearchHome() {
        //When
        let vc = wireframes.displayLocationSearchHome()
        
        //Then
        XCTAssertNotNil(vc)
        XCTAssertNotNil(vc?.presenter)
    }
    
    func testDisplayMapViewWithLocations() {
        //Given
        let location = LocationDetailViewModel.init(formattedAddress: "Address 1", lattitude: 12.123456, longitude: 23.123456, placeId: "PlaceId")
        
        //When
        let vc = wireframes.displayMapViewWithLocations(locations: [location])
        
        //Then
        XCTAssertNotNil(vc)
        XCTAssertNotNil(vc?.presenter)
    }
    
    func testDisplayMapViewWithSelectedLocation() {
        //Given
        let location = LocationDetailViewModel.init(formattedAddress: "Address 1", lattitude: 12.123456, longitude: 23.123456, placeId: "PlaceId")
        
        //When
        let vc = wireframes.displayMapViewWithLocations(locations: [location], selectedLocation: location)
        
        //Then
        XCTAssertNotNil(vc)
        XCTAssertNotNil(vc?.presenter)
    }
    
    
    override func tearDown() {
        wireframes = nil
        super.tearDown()
    }
    
}
