//
//  SeachLocationVC.swift
//  Fringe
//
//  Created by MyMac on 10/13/21.
//
import UIKit
import Foundation
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMapsBase

protocol PlacesSearchVCProtocol:class{
    func populateWith(lat: Double, long: Double, city: String, zip: String, state: String)
}

class PlacesCell : UITableViewCell{
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
}

class SeachLocationVC : BaseVC{
    
    @IBOutlet weak var tblLocation: UITableView!
    @IBOutlet weak var searchTF: FGEmailTextField!
    var fetcher: GMSAutocompleteFetcher?
    var delegate:PlacesSearchVCProtocol?
    var dataArray:[GMSAutocompletePrediction] = []{
        didSet{
            DispatchQueue.main.async {
                self.tblLocation.reloadData()
            }
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
    
    func setup() {
        let neBoundsCorner = CLLocationCoordinate2D(latitude: -33.843366, longitude: 151.134002)
        let swBoundsCorner = CLLocationCoordinate2D(latitude: -33.875725, longitude: 151.200349)
        let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner, coordinate: swBoundsCorner)
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        fetcher?.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        self.tblLocation.delegate = self
        self.tblLocation.dataSource = self
        self.tblLocation.separatorStyle = .none
    }
    @objc func textFieldDidChanged(_ textField:UITextField ){
        fetcher?.sourceTextHasChanged(textField.text!)
    }
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func getcurrentLocationBtnAction(_ sender: UIButton) {
        self.pop()
        self.delegate?.populateWith(lat: PreferenceManager.shared.lat ?? 0.0, long: PreferenceManager.shared.long ?? 0.0, city: "", zip: "", state: "")
    }
    //------------------------------------------------------
    
   
    //------------------------------------------------------
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationManager.shared.isEnabledBottomMenu = false
    }
    
    //------------------------------------------------------
    func getLatLongFromAutocompletePrediction(prediction:GMSAutocompletePrediction, city: String){
        let placeClient = GMSPlacesClient()
        placeClient.lookUpPlaceID(prediction.placeID) { (place, error) -> Void in
            if error != nil {
                //show error
                return
            }
            if let place = place {
              //  self.dismiss(animated: true) {
                
                    self.setPlaces(places: place.addressComponents!) { (dict) in
                        if let state = dict["state"] as? String, let zip = dict["zip"] as? String{
                            self.pop()
                            self.delegate?.populateWith(lat: place.coordinate.latitude, long: place.coordinate.longitude, city: city, zip: zip, state: state)
                        }
                    }
           //     }
            }else{
                
            }
        }
    }
    
    
    private func setPlaces(places: [GMSAddressComponent], completion: @escaping(([String:Any]) -> Void)){
        var state = ""
        var zip = ""
        for obj in places{
            for type in obj.types{
                switch type {
                case "administrative_area_level_1":
                    state = obj.name
                case "postal_code":
                    zip = obj.name
                default:
                    break
                }
            }
        }
        completion(["state":state, "zip":zip])
    }
}
extension SeachLocationVC: GMSAutocompleteFetcherDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        self.dataArray = predictions
    }

    func didFailAutocompleteWithError(_ error: Error) {
        print(error.localizedDescription)
    }
}
extension SeachLocationVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlacesCell
        cell.selectionStyle = .none
        let data = self.dataArray[indexPath.row]
        cell.titleLbl.text = data.attributedPrimaryText.string
        cell.subTitleLbl.text = data.attributedFullText.string
 //       cell.subTitleLbl.numberOfLines = 2
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.getLatLongFromAutocompletePrediction(prediction: self.dataArray[indexPath.row], city: self.dataArray[indexPath.row].attributedPrimaryText.string)
    }
}

fileprivate enum Section{
    case main
}
    
   
