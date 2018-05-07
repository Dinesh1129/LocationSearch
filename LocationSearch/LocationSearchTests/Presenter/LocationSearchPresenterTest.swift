//
//  LocationSearchPresenterTest.swift
//  LocationSearchTests
//
//  Created by Dinesh Selvaraj on 5/6/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import XCTest
import OHHTTPStubs


@testable import LocationSearch


class LocationSearchPresenterTest: XCTestCase {
    
    private var wireframes: LocationSearchWireframesMock!
    private var view: LocationSearchViewControllerMock!
    private var presenter: LocationSearchPresenterProtocol!
    private var locationSearchService: LocationSearchService!
    
    
    override func setUp() {
        super.setUp()
        
        view = LocationSearchViewControllerMock()
        wireframes = LocationSearchWireframesMock()
        locationSearchService = LocationSearchService.init()
        
        presenter = LocationSearchPresenter(view: view, wireframe: wireframes, locationSearchService: locationSearchService)
        view.presenter = presenter
    }
    
    func testInit() {
        //When
        let initedPresenter = LocationSearchPresenter(view: view, wireframe: wireframes, locationSearchService: locationSearchService)
        
        //Then
        XCTAssertNotNil(initedPresenter.view)
        XCTAssertTrue(initedPresenter.view === view)
        XCTAssertNotNil(initedPresenter.wireframe)
        XCTAssertNotNil(initedPresenter.locationManager)
        XCTAssertTrue(initedPresenter.locationManager === locationSearchService)
    }
    
    func testGetLocations() {
        
        //Given
        let exp = expectation(description: "Get Locations Multiplle Result")
        view.isViewLocadingCallBack = { [unowned self] in
            if self.view.isViewReloading {
                exp.fulfill()
            }
        }
        
        stub(condition: { request in
            return true
        }) { request in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("MultipleLocations.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        }

        
        //When
        presenter.onLocationSearch(with: "Concord")
        waitForExpectations(timeout: 5.0)
        
        //Then
        XCTAssertTrue(view.isReloadCalled)
        XCTAssertFalse(view.isReloadNoResultMessageCalled)
        
        //When
        presenter.onDisplayAllOnMap()
        
        //Then
        XCTAssertTrue(wireframes.isDisplayAllOnMapCalled)
        
    }
    
    func testZeroResults() {
        
        //Given
        let exp = expectation(description: "Get Zero Results")
        view.isViewLocadingCallBack = { [unowned self] in
            if self.view.isViewReloading {
                exp.fulfill()
            }
        }
        
        stub(condition: { request in
            return true
        }) { request in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("ZeroResults.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
        
        
        //When
        presenter.onLocationSearch(with: "Invalid Location")
        waitForExpectations(timeout: 5.0)
        
        //Then
        XCTAssertTrue(view.isReloadNoResultMessageCalled)
        XCTAssertFalse(view.isReloadCalled)
    }
    
    func testOnSelectingLocation() {
        //When
        presenter.onSelectingLocation(location:LocationDetailViewModel(formattedAddress: "Address", lattitude: 12.231234, longitude: 13.212342, placeId: "PlaceId"))
        
        //Then
        XCTAssertTrue(wireframes.isDisplayMapViewWithLocationsCalled)
    }
    
    override func tearDown() {
        view = nil
        wireframes = nil
        locationSearchService = nil
        
        super.tearDown()
    }
}

private class LocationSearchViewControllerMock: LocationSearchViewProtocol {
    
    var isReloadCalled = false
    var isReloadNoResultMessageCalled = false
    
    var presenter: LocationSearchPresenterProtocol!
    
    var isViewReloading = false {
        didSet {
            isViewLoadingCalled = true
            isViewLocadingCallBack?()
        }
    }
    
    var isViewLoadingCalled = false
    var isViewLocadingCallBack: (() -> ())?
    
    func reload() {
        isReloadCalled = true
        isViewReloading = true
    }
    
    func reloadNoResultsMessage() {
        isReloadNoResultMessageCalled = true
        isViewReloading = true
    }
    
    
    
}
