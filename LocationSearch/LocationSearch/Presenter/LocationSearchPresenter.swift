//
//  LocationSearchPresenter.swift
//  LocationSearch
//
//  Created by Dinesh Selvaraj on 5/2/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import Foundation

protocol LocationSearchPresenterProtocol {
    var view: LocationSearchViewProtocol {get}
    var searchResultCount: Int {get}
    var placeDetails: [LocationDetailViewModel] {get}
    
    func onLocationSearch(with location:String)
    func onDisplayAllOnMap()
    func onSelectingLocation(location: LocationDetailViewModel)
}

class LocationSearchPresenter : NSObject, LocationSearchPresenterProtocol {
    var wireframe: LocationSearchWireframeProtocol
    var locationManager: LocationSearchService
    init(view: LocationSearchViewProtocol, wireframe: LocationSearchWireframeProtocol, locationSearchService: LocationSearchService) {
        self.view = view
        self.wireframe = wireframe
        self.locationManager = locationSearchService
        super.init()
    }
    
    // MARK: - LocationSearchPresenterProtocol -
    unowned let view: LocationSearchViewProtocol
    
    func onLocationSearch(with location:String) {
        locationManager.getLocationSearchResults(location: location) {[weak self](locationResponse, error) in
            guard let strongSelf = self else {return}
            
            guard let response = locationResponse, let _ = response.locationSearchResults else {
                strongSelf.view.reloadNoResultsMessage()
                return
            }
            
            if response.status == "ZERO_RESULTS" {
                strongSelf.view.reloadNoResultsMessage()
                return
            }
            else if response.status == "OK" {
                strongSelf.view.reload()
                return
            }
        }
    }
    
    func onDisplayAllOnMap() {
        wireframe.displayMapViewWithLocations(locations: placeDetails)
    }
    
    func onSelectingLocation(location: LocationDetailViewModel) {
        wireframe.displayMapViewWithLocations(locations: placeDetails, selectedLocation: location)
    }
    
    var searchResultCount: Int {
        return locationManager.placeDetails?.count ?? 0
    }
    
    var placeDetails: [LocationDetailViewModel] {
        guard let locationDetails: [PlaceDetails] = locationManager.placeDetails else {return []}
        var locations: [LocationDetailViewModel] = []
        
        for location: PlaceDetails in locationDetails {
            let locationModel = LocationDetailViewModel(formattedAddress: location.formattedAddress, lattitude: location.geometry.location.lattitude, longitude: location.geometry.location.longitude, placeId: location.placeId)
            locations.append(locationModel)
        }
        return locations
    }
    
}
