//
//  LocationSearchPresenterMock.swift
//  LocationSearchTests
//
//  Created by Dinesh Selvaraj on 5/5/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import Foundation
@testable import LocationSearch

class LocationSearchPresenterMock: LocationSearchPresenterProtocol {
   
    var viewDidLoadCalled = false
    
    var locationSearchCalled = false
    
    var displayAllOnMapCalled = false
    
    var selectingLocationCalled = false
    
    init(_ view: LocationSearchViewProtocol) {
        self.view = view
    }
    
    //MARK: - LocationSearchPresenterProtocol Methods
    var view: LocationSearchViewProtocol
    
    var searchResultCount = 10
    
    var placeDetails: [LocationDetailViewModel] = []
    
    func onViewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func onLocationSearch(with location: String) {
        locationSearchCalled = true
    }
    
    func onDisplayAllOnMap() {
        displayAllOnMapCalled = true
    }
    
    func onSelectingLocation(location: LocationDetailViewModel) {
        selectingLocationCalled = true
    }
    
    
}
