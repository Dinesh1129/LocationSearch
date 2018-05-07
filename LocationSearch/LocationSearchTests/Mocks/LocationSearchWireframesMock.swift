//
//  LocationSearchWireframesMock.swift
//  LocationSearchTests
//
//  Created by Dinesh Selvaraj on 5/6/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

@testable import LocationSearch

class LocationSearchWireframesMock: LocationSearchWireframeProtocol {
    
    var isDisplayLocationSearchHomeCalled = false
    var isDisplayMapViewWithLocationsCalled = false
    var isDisplayAllOnMapCalled = false
    
    func displayLocationSearchHome() -> LocationSearchViewProtocol? {
        isDisplayLocationSearchHomeCalled = true
        return nil
    }
    
    func displayMapViewWithLocations(locations: [LocationDetailViewModel], selectedLocation: LocationDetailViewModel) -> LocationMapViewProtocol? {
        isDisplayMapViewWithLocationsCalled = true
        return nil
    }
    
    func displayMapViewWithLocations(locations: [LocationDetailViewModel]) -> LocationMapViewProtocol? {
        if locations.count > 1 {
            isDisplayAllOnMapCalled = true
        }
        else{
            isDisplayMapViewWithLocationsCalled = true
        }
        return nil
    }
    
    

}
