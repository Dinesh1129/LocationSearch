//
//  LocationSearchWireframes.swift
//  LocationSearch
//
//  Created by Dinesh Selvaraj on 5/2/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import UIKit

enum LocationMapViewEntry: Int {
    case displayAllOnMap = 0
    case locationResult
}

protocol LocationSearchWireframeProtocol {
    
    @discardableResult
    func displayLocationSearchHome() -> LocationSearchViewProtocol?
    
    @discardableResult
    func displayMapViewWithLocations(locations: [LocationDetailViewModel], selectedLocation: LocationDetailViewModel) -> LocationMapViewProtocol?
    
    @discardableResult
    func displayMapViewWithLocations(locations: [LocationDetailViewModel]) -> LocationMapViewProtocol?
}

class LocationSearchWireframe: NSObject, LocationSearchWireframeProtocol {
    
    var navigationController: UINavigationController?
    
    @discardableResult
    func displayLocationSearchHome() -> LocationSearchViewProtocol? {
        let locationSearchVC = LocationSearchViewController.init(nibName: "LocationSearchViewController", bundle: nil)
        let locationSearchService = LocationSearchService.init()
        let presenter = LocationSearchPresenter.init(view: locationSearchVC, wireframe: self, locationSearchService: locationSearchService)
        locationSearchVC.presenter = presenter
        display(viewController: locationSearchVC)
        return locationSearchVC
    }
    
    @discardableResult
    func displayMapViewWithLocations(locations: [LocationDetailViewModel], selectedLocation: LocationDetailViewModel) -> LocationMapViewProtocol? {
        let locationMapVC = LocationMapViewController.init(nibName: "LocationMapViewController", bundle: nil)
        let presenter = LocationMapPresenter.init(view: locationMapVC, locationDetails: locations, selectedLocation: selectedLocation, wireframe: self, entry: LocationMapViewEntry.locationResult)
        locationMapVC.presenter = presenter
        display(viewController: locationMapVC)
        return locationMapVC
    }
    
    @discardableResult
    func displayMapViewWithLocations(locations: [LocationDetailViewModel]) -> LocationMapViewProtocol? {
        let locationMapVC = LocationMapViewController.init(nibName: "LocationMapViewController", bundle: nil)
        let presenter = LocationMapPresenter.init(view: locationMapVC, locationDetails: locations, selectedLocation: nil, wireframe: self, entry: LocationMapViewEntry.displayAllOnMap)
        locationMapVC.presenter = presenter
        display(viewController: locationMapVC)
        return locationMapVC
    }
    
    
    private func display(viewController: Any, animated: Bool = true) {
        guard let viewController = viewController as? UIViewController else {return}
        
        if let nav = navigationController {
            nav.pushViewController(viewController, animated: animated)
        }
        else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.navController?.pushViewController(viewController, animated: true)
        }
    }
}
