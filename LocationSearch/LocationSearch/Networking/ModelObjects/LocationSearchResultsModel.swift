//
//  LocationSearchResultsModel.swift
//  LocationSearch
//
//  Created by Dinesh Selvaraj on 5/3/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import ObjectMapper

public class LocationResponse: ImmutableMappable {
    var locationSearchResults: [PlaceDetails]?
    var status: String
    
    required public init(map: Map) throws {
        locationSearchResults = try? map.value("results")
        status =  try map.value("status")
    }
}

public class PlaceDetails: ImmutableMappable {
    var addressComponents: [AddressComponents]?
    var formattedAddress: String
    var geometry: Geometry
    var placeId: String
    var placeDetailTypes: [String]?

    required public init(map: Map) throws {
        addressComponents = try? map.value("address_components")
        formattedAddress = try map.value("formatted_address")
        geometry = try map.value("geometry")
        placeId = try map.value("place_id")
        placeDetailTypes = try? map.value("types")
    }
}

class AddressComponents: ImmutableMappable {
    var longName: String
    var shortName: String
    var locationTypes: [String]?

    required public init(map: Map) throws{
        longName = try map.value("long_name")
        shortName = try map.value("short_name")
        locationTypes = try? map.value("types")
    }
}

class Geometry: ImmutableMappable {
    var northEastBounds: Coordinate?
    var southwestBounds: Coordinate?
    var location: Coordinate
    var locationType: String?
    var northEastViewport: Coordinate?
    var southwestViewport: Coordinate?
    
    required public init(map: Map) throws {
        northEastBounds = try? map.value("bounds.northeast")
        southwestBounds = try? map.value("bounds.southwest")
        location = try map.value("location")
        locationType = try? map.value("location_type")
        northEastViewport = try? map.value("viewport.northeast")
        southwestViewport = try? map.value("viewport.southwest")
    }
}

class Coordinate: ImmutableMappable {
    var lattitude: Double
    var longitude: Double
    
    required public init(map: Map) throws{
        lattitude = try map.value("lat")
        longitude = try map.value("lng")
    }
}



