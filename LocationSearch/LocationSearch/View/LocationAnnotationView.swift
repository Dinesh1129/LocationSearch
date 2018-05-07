//
//  LocationAnnotationView.swift
//  LocationSearch
//
//  Created by Dinesh Selvaraj on 5/3/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import MapKit

class LocationAnnotationView: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        let lat = String(coordinate.latitude)
        let lng = String(coordinate.longitude)
        self.subtitle = "("+lat+" "+lng+")"
        self.coordinate = coordinate
        super.init()
    }
}
