//
//  LocationSearchVC.swift
//  SessionControl
//
//  Created by Dharmesh Avaiya on 5/13/21.
//  Copyright © 2021 dharmesh. All rights reserved.
//

import UIKit
import Foundation
import MapKit

protocol LocationSearchDelegate {
    
    func locationSearch(controller: LocationSearchVC, didSelect location: MKPlacemark)
}

class LocationSearchVC: UITableViewController, UISearchBarDelegate, FGLocationManagerDelegate {
    
    @IBOutlet weak var tblSearch: UITableView!
    
    var delegate: LocationSearchDelegate?
    
    private enum SegueID: String {
        case showDetail
        case showAll
    }
    
    private enum CellReuseID: String {
        case resultCell
    }
    
    private var places: [MKMapItem]? {
        didSet {
            tableView?.reloadData()
        }
    }
    
    private var suggestionController: LocationSearchSuggestionsVC!
    private var searchController: UISearchController!
    
    private var currentPlacemark: CLPlacemark?
    private var boundingRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    
    private var foregroundRestorationObserver: NSObjectProtocol?
    
    private var localSearch: MKLocalSearch? {
        willSet {
            // Clear the results and cancel the currently running local search before starting a new search.
            places = nil
            localSearch?.cancel()
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    /// - Parameter suggestedCompletion: A search completion provided by `MKLocalSearchCompleter` when tapping on a search completion table row
    private func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        search(using: searchRequest)
    }
    
    /// - Parameter queryString: A search string from the text the user entered into `UISearchBar`
    private func search(for queryString: String?) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = queryString
        search(using: searchRequest)
    }
    
    /// - Tag: SearchRequest
    private func search(using searchRequest: MKLocalSearch.Request) {
        
        // Confine the map search area to an area around the user's current location.
        searchRequest.region = boundingRegion
        
        // Include only point of interest results. This excludes results based on address matches.
        searchRequest.resultTypes = .pointOfInterest
        
        localSearch = MKLocalSearch(request: searchRequest)
        localSearch?.start { [unowned self] (response, error) in
            guard error == nil else {
                self.displaySearchError(error)
                return
            }
            let result = response?.mapItems.sorted(by: { (arg0: MKMapItem, arg1: MKMapItem) -> Bool in
                let location0 = CLLocation(latitude: arg0.placemark.coordinate.latitude, longitude: arg0.placemark.coordinate.longitude)
                let location1 = CLLocation(latitude: arg1.placemark.coordinate.latitude, longitude: arg1.placemark.coordinate.longitude)
                let location2 = CLLocation(latitude: PreferenceManager.shared.lat ?? .zero, longitude: PreferenceManager.shared.long ?? .zero)
                let distance0 = location1.distance(from: location0)
                let distance1 = location2.distance(from: location1)
                return distance0 <= distance1
                
            })
            self.places = result
            
            // Used when setting the map's region in `prepareForSegue`.
            if let updatedRegion = response?.boundingRegion {
                self.boundingRegion = updatedRegion
            }
        }
    }
    
    private func displaySearchError(_ error: Error?) {
        if let error = error as NSError?, let errorString = error.userInfo[NSLocalizedDescriptionKey] as? String {
            let alertController = UIAlertController(title: "Could not find any places.", message: errorString, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func setupDefaultSearch() {
        search(for: "all")
    }
    
    //------------------------------------------------------
    
    //MARK: UISearchBarDelegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        setupDefaultSearch()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            search(for: searchBar.text)
        } else {
            setupDefaultSearch()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // The user tapped search on the `UISearchBar` or on the keyboard. Since they didn't
        // select a row with a suggested completion, run the search with the query text in the search field.
        search(for: searchBar.text)
    }
    
    //------------------------------------------------------
    
    //MARK: TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if places?.count == nil{
            
            self.tableView.setEmptyMessage("No address found")
            
        }else{
            
            self.tableView.restore()
            
        }
        return places?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.resultCell.rawValue, for: indexPath)
        
        if let mapItem = places?[indexPath.row] {
//            let coordinate0 = SCLocationManager.shared.location
            let coordinate0 = CLLocationCoordinate2D(latitude: PreferenceManager.shared.lat ?? .zero, longitude: PreferenceManager.shared.long ?? .zero)
            let coordinate1 = mapItem.placemark.coordinate
            let kmString = getDistanceInKm(from: coordinate0, coordinate1: coordinate1)
            cell.textLabel?.text = String(format: "%@ - %@", kmString, mapItem.name ?? String())
            cell.detailTextLabel?.text = mapItem.placemark.formattedAddress
        }
        
        return cell
    }
        
    //------------------------------------------------------
    
    //MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        /*if tableView == suggestionController.tableView, let suggestion = suggestionController.completerResults?[indexPath.row] {
            /*searchController.isActive = false
            searchController.searchBar.text = suggestion.title
            search(for: suggestion)*/
        }*/
        
        if places?.indices.contains(indexPath.row) == true {
            let selectedObject = places![indexPath.row]
           // delegate?.locationSearch(controller: self, didSelect: selectedObject.placemark.formattedAddress ?? selectedObject.name ?? String())
            delegate?.locationSearch(controller: self, didSelect: selectedObject.placemark)
            self.dismiss(animated: true) {
                
            }
        }
    }
    
    //------------------------------------------------------
    
    //MARK: SCLocationManagerDelegate
    
    func locationManager(_ manager: FGLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemark, error) in
            guard error == nil else { return }
            self.currentPlacemark = placemark?.first
            self.boundingRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 12_000, longitudinalMeters: 12_000)
            self.suggestionController?.updatePlacemark(self.currentPlacemark, boundingRegion: self.boundingRegion)
        }
    }
    
    func locationManager(_ manager: FGLocationManager, didFailWithError error: Error) {
        
        //TODO: Handle location failure
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        FGLocationManager.shared.delegate = self
        
        //suggestionController = LocationSearchSuggestionsVC(style: .grouped)
        //suggestionController.tableView.delegate = self
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        //searchController = UISearchController(searchResultsController: suggestionController)
        //searchController.searchResultsUpdater = suggestionController
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.searchTextField.font = FGFont.PoppinsRegular(size: searchController.searchBar.searchTextField.font?.pointSize)
        
        let name = UIApplication.willEnterForegroundNotification
        foregroundRestorationObserver = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: { [unowned self] (_) in
            // Get a new location when returning from Settings to enable location services.
            //self.requestLocation()
            FGLocationManager.shared.requestForLocationPermission()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Place the search bar in the navigation bar.
        navigationItem.searchController = searchController
        
        // Keep the search bar visible at all times.
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        
        /*
         Search is presenting a view controller, and needs the presentation context to be defined by a controller in the
         presented view controller hierarchy.
         */
        definesPresentationContext = true
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDefaultSearch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //------------------------------------------------------
}

