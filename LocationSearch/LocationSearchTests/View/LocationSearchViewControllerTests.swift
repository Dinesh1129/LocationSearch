//
//  LocationSearchViewControllerTests.swift
//  LocationSearchTests
//
//  Created by Dinesh Selvaraj on 5/5/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import XCTest
@testable import LocationSearch

class LocationSearchViewControllerTests: XCTestCase {
    
    var viewController: LocationSearchViewController!
    var presenterMock: LocationSearchPresenterMock!
    override func setUp() {
        super.setUp()
        viewController = LocationSearchViewController(nibName: "LocationSearchViewController", bundle: nil)
        presenterMock = LocationSearchPresenterMock(viewController)
        viewController.presenter = presenterMock
        _ = viewController.view
    }
    
    func testCellsCorrectlyRegistered(){
        //When
        let singleResultCell = viewController.tableViewSearchResults.dequeueReusableCell(withIdentifier: Constants.searchSingleResultCellReuseID, for: IndexPath(row: 0, section: 0))
        
        let multipleResultCell = viewController.tableViewSearchResults.dequeueReusableCell(withIdentifier: Constants.searchMultipleResultCellReuseID, for: IndexPath(row: 0, section: 1))
        
        //Then
        XCTAssertNotNil(singleResultCell)
        XCTAssertNotNil(multipleResultCell)
    }
    
    func testSingleSearchResult(){
        //Given
        presenterMock.searchResultCount = 1
        let locationDetailViewModel1 = LocationDetailViewModel(formattedAddress: "Test Address 1", lattitude: 12.0000, longitude: 13.000, placeId: "testPlaceID1")
        presenterMock.placeDetails.append(locationDetailViewModel1)
        
        //When
        viewController.tableView(viewController.tableViewSearchResults, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        //Then
        XCTAssertTrue(presenterMock.selectingLocationCalled)
    }
    
    func testMultipleSearchResult(){
        //Given
        presenterMock.searchResultCount = 2
        
        let locationDetailViewModel1 = LocationDetailViewModel(formattedAddress: "Test Address 1", lattitude: 12.0000, longitude: 13.000, placeId: "testPlaceID1")
        let locationDetailViewModel2 = LocationDetailViewModel(formattedAddress: "Test Address 2", lattitude: 12.0000, longitude: 13.000, placeId: "testPlaceID2")
        
        presenterMock.placeDetails = [locationDetailViewModel1, locationDetailViewModel2]
        
        //When
        viewController.tableView(viewController.tableViewSearchResults, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        //Then
        XCTAssertTrue(presenterMock.displayAllOnMapCalled)
        

        //When
        viewController.tableView(viewController.tableViewSearchResults, didSelectRowAt: IndexPath(row: 0, section: 1))
        
        //Then
        XCTAssertTrue(presenterMock.selectingLocationCalled)
    }
    
    func testTableViewForSingleSearchResult(){
        //Given
        presenterMock.searchResultCount = 1
        
        let locationDetailViewModel1 = LocationDetailViewModel(formattedAddress: "Test Address 1", lattitude: 12.0000, longitude: 13.000, placeId: "testPlaceID1")
        presenterMock.placeDetails.append(locationDetailViewModel1)
        
        //When
        viewController.reload()
        
        //Then
        XCTAssertTrue(viewController.labelNoResults.isHidden)
        XCTAssertFalse(viewController.tableViewSearchResults.isHidden)
        XCTAssertEqual(viewController.tableView(viewController.tableViewSearchResults, numberOfRowsInSection: 0), 1)
        let cell = viewController.tableView(viewController.tableViewSearchResults, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cell.textLabel?.text!, "Test Address 1")
        
    }
    
    func testTableViewForMultipleSearchResult(){
        //Given
        presenterMock.searchResultCount = 2
        
        let locationDetailViewModel1 = LocationDetailViewModel(formattedAddress: "Test Address 1", lattitude: 12.0000, longitude: 13.000, placeId: "testPlaceID1")
        let locationDetailViewModel2 = LocationDetailViewModel(formattedAddress: "Test Address 2", lattitude: 22.0000, longitude: 23.000, placeId: "testPlaceID2")
        presenterMock.placeDetails.append(locationDetailViewModel1)
        presenterMock.placeDetails.append(locationDetailViewModel2)
        
        //When
        viewController.reload()
        
        //Then
        XCTAssertTrue(viewController.labelNoResults.isHidden)
        XCTAssertFalse(viewController.tableViewSearchResults.isHidden)
        XCTAssertEqual(viewController.tableView(viewController.tableViewSearchResults, numberOfRowsInSection: 0), 1)
        XCTAssertEqual(viewController.tableView(viewController.tableViewSearchResults, numberOfRowsInSection: 1), 2)
        let cellForSection1 = viewController.tableView(viewController.tableViewSearchResults, cellForRowAt: IndexPath(row: 0, section: 0))
        let cellForSection2Row1 = viewController.tableView(viewController.tableViewSearchResults, cellForRowAt: IndexPath(row: 0, section: 1))
        let cellForSection2Row2 = viewController.tableView(viewController.tableViewSearchResults, cellForRowAt: IndexPath(row: 1, section: 1))
        XCTAssertEqual(cellForSection1.textLabel?.text!, "Display All on Map")
        XCTAssertEqual(cellForSection2Row1.textLabel?.text!, "Test Address 1")
        XCTAssertEqual(cellForSection2Row2.textLabel?.text!, "Test Address 2")
    }
    
    func testSearchBarSearchButtonClicked(){
        //Given
        let searchBar = UISearchBar.init()
        searchBar.text = "Concord"
        
        //When
        viewController.searchBarSearchButtonClicked(searchBar)
        
        //Then
        XCTAssertTrue(presenterMock.locationSearchCalled)
    }
    
    
    override func tearDown() {
        viewController = nil
        presenterMock = nil
        super.tearDown()
    }
}
