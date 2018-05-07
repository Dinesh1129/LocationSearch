//
//  LocationMapPresenterMock.swift
//  LocationSearchTests
//
//  Created by Dinesh Selvaraj on 5/5/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import Foundation
@testable import LocationSearch

class LocationMapPresenterMock: LocationMapPresenterProtocol {
    
    var viewWillAppearCalled = false
    var locationSaveCalled = false
    var locationDeleteCalled = false
    var showRightBarButtonCalled = false
    var locationAvailableInDBCalled = false
    
    var islocationAvailableInDB = false
    var entry : LocationMapViewEntry
    
    init(_ view: LocationMapViewProtocol, entry: LocationMapViewEntry) {
        self.view = view
        self.entry = entry
    }
    
    //MARK: - LocationMapPresenterProtocol Methods
    var view: LocationMapViewProtocol
    
    var centerLocation: LocationDetailViewModel?
    
    var allLocations = [LocationDetailViewModel] ()
    
    func onViewWillAppear() {
        viewWillAppearCalled = true
    }
    
    func onLocationSave(location: LocationDetailViewModel) {
        locationSaveCalled = true
    }
    
    func onLocationDelete() {
        locationDeleteCalled = true
    }
    
    func shouldShowRightBarButton() -> Bool {
        showRightBarButtonCalled = true
        return entry == .locationResult
    }
    
    func isLocationAvailableInDB() -> Bool {
        locationAvailableInDBCalled = true
        return islocationAvailableInDB
    }
    
}
