//
//  LocationMapPresenter.swift
//  LocationSearch
//
//  Created by Dinesh Selvaraj on 5/3/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import Foundation

protocol LocationMapPresenterProtocol {
    var view: LocationMapViewProtocol {get}
    var centerLocation: LocationDetailViewModel? {get}
    var allLocations: [LocationDetailViewModel] {get}
    
    func onViewWillAppear()
    func onLocationSave(location: LocationDetailViewModel)
    func onLocationDelete()
    func shouldShowRightBarButton() -> Bool
    func isLocationAvailableInDB() -> Bool
}

class LocationMapPresenter : NSObject, LocationMapPresenterProtocol {
 
    var wireframe: LocationSearchWireframe
    var locationDetails: [LocationDetailViewModel]
    var selectedLocation: LocationDetailViewModel?
    var entry: LocationMapViewEntry
    
    lazy var locationStoreManager: LocationStorageManager = {
        return LocationStorageManager.init()
    }()
    
    init(view: LocationMapViewProtocol, locationDetails: [LocationDetailViewModel], selectedLocation: LocationDetailViewModel?, wireframe:LocationSearchWireframe, entry: LocationMapViewEntry ) {
        self.view = view
        self.wireframe = wireframe
        self.locationDetails = locationDetails
        self.selectedLocation = selectedLocation
        self.entry = entry
    }
    // MARK: - LocationSearchPresenterProtocol -
    unowned let view: LocationMapViewProtocol
    
    var centerLocation: LocationDetailViewModel? {
        if locationDetails.count == 1 {
            return locationDetails.first
        }
        return selectedLocation
    }
    
    var allLocations: [LocationDetailViewModel] {
        return locationDetails
    }
    
    func onViewWillAppear() {
    }
    
    func onLocationSave(location: LocationDetailViewModel) {
        locationStoreManager.insertLocationItem(location)
        locationStoreManager.save()
    }
    
    func onLocationDelete() {
        let locations = self.locationStoreManager.fetchAllLocations()
        
        for locationDetail: LocationDetail in locations {
            if let placeID = locationDetail.placeId, let selectedLocation = centerLocation {
                if placeID == selectedLocation.placeId {
                    self.locationStoreManager.deleteLocationItem(locationDetail.objectID)
                    self.locationStoreManager.save()
                }
            }
        }
    }
    
    func shouldShowRightBarButton() -> Bool {
        return entry == .locationResult
    }
    
    func isLocationAvailableInDB() -> Bool {
        let locations = self.locationStoreManager.fetchAllLocations()
        
        for locationDetail: LocationDetail in locations {
            if let placeID = locationDetail.placeId, let selectedLocation = centerLocation {
                if placeID == selectedLocation.placeId {
                    return true
                }
            }
        }
        return false
    }
}
