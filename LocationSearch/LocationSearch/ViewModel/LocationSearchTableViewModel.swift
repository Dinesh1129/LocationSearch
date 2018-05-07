//
//  LocationSearchTableViewModel.swift
//  LocationSearch
//
//  Created by Dinesh Selvaraj on 5/3/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import Foundation

enum Constants {
    static let searchSingleResultCellReuseID = "seacrhSignleResultCell"
    static let searchMultipleResultCellReuseID = "searchMultipleResultCell"
}

enum LocationSearchTableViewModel: Int {
    case searchSigleResultSection = 0
    case searchMultipleResultSection
    case sectionCount
    
    static func cellReuseIdentifier(for section: Int) -> String? {
        guard let section = LocationSearchTableViewModel(rawValue: section) else {
            return nil
        }
        
        switch section {
        case .searchSigleResultSection:
            return Constants.searchSingleResultCellReuseID
        case .searchMultipleResultSection:
            return Constants.searchMultipleResultCellReuseID
        case .sectionCount:
            return nil
        }
    }
}


