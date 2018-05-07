//
//  LocationMapViewController.swift
//  LocationSearch
//
//  Created by Dinesh Selvaraj on 5/3/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import UIKit
import MapKit
import CoreData

protocol LocationMapViewProtocol: class {
    var presenter: LocationMapPresenterProtocol! {get set}
}

class LocationMapViewController: UIViewController, LocationMapViewProtocol {

    @IBOutlet weak var mapView: MKMapView!
    var presenter: LocationMapPresenterProtocol!
    
    enum Constants {
        static let regionRadius: CLLocationDistance = 1000
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
        if presenter.shouldShowRightBarButton(){
            setNavigationRightBarButton()
        }
        
        addAnnotations()
        
        if let centerLocation = presenter.centerLocation {
            let initialLocation = CLLocation(latitude: centerLocation.lattitude, longitude: centerLocation.longitude)
           centerMapOnLocation(location: initialLocation)
        }
        
    }
    
    func saveButtonSelected(){
        
        guard let locationViewModel = presenter.centerLocation else {
            return
        }
        presenter.onLocationSave(location: locationViewModel)
        configureDeleteButton()
    }
    
    func deleteButtonSelected(){
        
        let alert = UIAlertController.init(title: "Delete", message: "Do you want to delete the entry from database", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction.init(title: "Delete", style: .default) {
            [unowned self] action in
            self.deleteLocation()
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    //MARK: - Private Helper Method
    
    private func addAnnotations() {
        
        var zoomRect: MKMapRect = MKMapRect()
        
        for location: LocationDetailViewModel in presenter.allLocations {
            let annotation = LocationAnnotationView(title: location.formattedAddress, coordinate: CLLocationCoordinate2D(latitude:location.lattitude, longitude: location.longitude))
            mapView.addAnnotation(annotation)
            
            let annotationPoint: MKMapPoint = MKMapPointForCoordinate(annotation.coordinate)
            let pointRect: MKMapRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1)
            zoomRect = MKMapRectUnion(zoomRect, pointRect)
        }
        
        let inset = -zoomRect.size.width * 0.1
        mapView.setVisibleMapRect(MKMapRectInset(zoomRect, inset, inset), animated: true)
    }
    
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, Constants.regionRadius, Constants.regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func setNavigationRightBarButton(){
        
        if presenter.isLocationAvailableInDB() {
           configureDeleteButton()
        }
        else{
            configureSaveButton()
        }
    }
    
    private func configureDeleteButton(){
        let rightBatButton = UIBarButtonItem.init(title: "Delete", style: .plain, target: self, action: #selector(deleteButtonSelected))
        self.navigationItem.rightBarButtonItem = rightBatButton
    }
    
    private func configureSaveButton(){
        let rightBatButton = UIBarButtonItem.init(title: "Save", style: .plain, target: self, action: #selector(saveButtonSelected))
        self.navigationItem.rightBarButtonItem = rightBatButton
    }
    
    private func deleteLocation() {
        presenter.onLocationDelete()
        configureSaveButton()
    }
}

extension LocationMapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? LocationAnnotationView else { return nil }

        let identifier = "marker"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
