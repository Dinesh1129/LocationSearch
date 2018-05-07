//
//  LocationDetailViewModel.swift
//  LocationSearch
//
//  Created by Dinesh Selvaraj on 5/4/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import Foundation

class LocationDetailViewModel: NSObject {
    let formattedAddress: String
    let lattitude: Double
    let longitude: Double
    let placeId: String
    
    init(formattedAddress: String, lattitude: Double, longitude: Double, placeId: String) {
        self.formattedAddress = formattedAddress
        self.lattitude = lattitude
        self.longitude = longitude
        self.placeId = placeId
        super.init()
    }
}
