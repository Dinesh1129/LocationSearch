//
//  LocationSearchViewController.swift
//  LocationSearch
//
//  Created by Dinesh Selvaraj on 5/3/18.
//  Copyright © 2018 ABCD. All rights reserved.
//

import UIKit
import Foundation

protocol LocationSearchViewProtocol :  class {
    var presenter: LocationSearchPresenterProtocol! { get set}
    func reload()
    func reloadNoResultsMessage()
}

class LocationSearchViewController: UIViewController, LocationSearchViewProtocol {
    
    @IBOutlet weak var labelNoResults: UILabel!
    @IBOutlet weak var searchBarLocation: UISearchBar!
    @IBOutlet weak var tableViewSearchResults: UITableView!
    var presenter: LocationSearchPresenterProtocol!
    
    func reload() {
        tableViewSearchResults.isHidden = false
        labelNoResults.isHidden = true
        tableViewSearchResults.reloadData()
    }
    
    func reloadNoResultsMessage() {
        tableViewSearchResults.isHidden = true
        labelNoResults.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        searchBarLocation.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)

    }
    
    func keyboardDidShow(notification: NSNotification) {
        
        let keyboardSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        
        let height = keyboardSize.width
        tableViewSearchResults.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
    }
    
    func keyboardDidHide(notification: NSNotification) {
        tableViewSearchResults.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func registerCells() {
        tableViewSearchResults.register(UITableViewCell.self, forCellReuseIdentifier: Constants.searchSingleResultCellReuseID)
        tableViewSearchResults.register(UITableViewCell.self, forCellReuseIdentifier: Constants.searchMultipleResultCellReuseID)
    }
    
}

extension LocationSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return LocationSearchTableViewModel.sectionCount.rawValue
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = LocationSearchTableViewModel(rawValue: section) else { return 0 }
        
            switch section {
            case .searchSigleResultSection:
                return (presenter.searchResultCount != 0) ? 1 : 0
            case .searchMultipleResultSection:
                return (presenter.searchResultCount > 1) ? presenter.searchResultCount : 0
            case .sectionCount:
                return 0
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let identifier = LocationSearchTableViewModel.cellReuseIdentifier(for: indexPath.section) else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        guard let section = LocationSearchTableViewModel(rawValue: indexPath.section) else { return cell }
        
        switch section {
        case .searchSigleResultSection:
            if presenter.searchResultCount == 1 {
                cell.textLabel?.text = presenter.placeDetails.first?.formattedAddress
            }
            else{
                cell.textLabel?.text = "Display All on Map"
            }
        case .searchMultipleResultSection:
            cell.textLabel?.text = presenter.placeDetails[indexPath.row].formattedAddress
        case .sectionCount:
            ()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchBarLocation.isFirstResponder {
            searchBarLocation.resignFirstResponder()
        }
        
        if indexPath.section == 0 && presenter.placeDetails.count > 1 {
            presenter.onDisplayAllOnMap()
        }
        else{
            presenter.onSelectingLocation(location: presenter.placeDetails[indexPath.row])
        }
    }
}

extension LocationSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        
        presenter.onLocationSearch(with: searchText)
        
    }
}
