//
//  LocationSearchService.swift
//  LocationSearch
//
//  Created by Dinesh Selvaraj on 5/3/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire

public class LocationSearchService: NSObject {

    enum Constants {
        static let endPoint = "http://maps.googleapis.com/maps/api/geocode/json"
    }
    
    public private(set) var placeDetails: [PlaceDetails]?
    public typealias GetLocationSearchResultsCompletionHandler = (_ response: LocationResponse?, _ error:Error?) -> Void
    
    public func getLocationSearchResults(location: String, sensor: String = "false", completionHandler: GetLocationSearchResultsCompletionHandler?) {
        let completeURL = Constants.endPoint+"?"+"address=\(location)"+"&sensor=\(sensor)"
        Alamofire.request(completeURL).responseObject{ [weak self] (response: DataResponse<LocationResponse>) in
            
            guard let strongSelf = self else {return}
            
            guard response.result.isSuccess else {
                completionHandler?(nil, response.result.error)
                return
            }
            guard let locationResponse = response.result.value else {
                completionHandler?(nil, nil)
                return
            }
            strongSelf.placeDetails = locationResponse.locationSearchResults
            completionHandler?(locationResponse, nil)
        }
    }
}
