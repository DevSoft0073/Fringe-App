//
//  HomeVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 12/08/21.
//

import UIKit
import MapKit
import Alamofire
import Foundation
import CoreLocation
import FittedSheets
import SDWebImage
import IQKeyboardManagerSwift

class HomeVC : BaseVC, FGLocationManagerDelegate , CLLocationManagerDelegate{
    
    
    @IBOutlet weak var imgNotif: UIImageView!
    @IBOutlet weak var locationsMap: MKMapView!
    @IBOutlet weak var lblPrice: FGMediumLabel!
    @IBOutlet weak var lblRating: FGRegularLabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblAddress: FGRegularLabel!
    @IBOutlet weak var imgFavUnfav: UIImageView!
    @IBOutlet weak var lblName: FGSemiboldLabel!
    @IBOutlet weak var imgMain: UIImageView!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var items: [HomeModal] = []
    var isRequesting: Bool = false
    var lastRequestId: String = String()
    var locationManager: CLLocationManager!
    var manager = FGLocationManager()
    var annotation = MKPointAnnotation()
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Custome
    
    func bottomSheetView(){
        
        if PreferenceManager.shared.comesFromHomeListing == true {
            
            let controller = HomeListingVC.instantiate()
            var sizes = [SheetSize]()
            sizes.append(.fixed(UIScreen.main.bounds.size.height * 0.9))
            sizes.append(.marginFromTop(60))
            let sheetController = SheetViewController(controller: controller, sizes: sizes)
            self.present(sheetController, animated: true, completion: nil)
            
        } else {
            
            let controller = HomeListingVC.instantiate()
            var sizes = [SheetSize]()
            sizes.append(.fixed(UIScreen.main.bounds.size.height * 0.5))
            sizes.append(.marginFromTop(60))
            let sheetController = SheetViewController(controller: controller, sizes: sizes)
            self.present(sheetController, animated: true, completion: nil)
        }
    }
    
    func setupData() {
        
        lblName.text = items.first?.golfCourseName
        lblAddress.text = items.first?.location
        lblPrice.text = "$\(items.first?.price ?? String())"
        lblRating.text = items.first?.rating
        ratingView.rating = Double(items.first?.rating ?? String()) ?? 0.0
        
        //image
        
        imgMain.sd_addActivityIndicator()
        imgMain.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
        imgMain.sd_showActivityIndicatorView()
        imgMain.image = getPlaceholderImage()
        
        if items.first?.golfImages?.count ?? 0 > 0{
            if let image = items.first?.golfImages?[0], image.isEmpty == false {
                let imgURL = URL(string: image)
                imgMain.sd_setImage(with: imgURL) { ( serverImage: UIImage?, _: Error?, _: SDImageCacheType, _: URL?) in
                    self.imgMain.sd_removeActivityIndicator()
                }
            } else {
                self.imgMain.sd_removeActivityIndicator()
            }
        } else {
            self.imgMain.sd_removeActivityIndicator()
            imgMain.image = UIImage(named: FGImageName.imgPlaceHolder)
        }
    }
    
    func performGetNearByGolfClubs(completion:((_ flag: Bool) -> Void)?) {
        
        isRequesting = true
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        let parameter: [String: Any] = [
            Request.Parameter.lastID: lastRequestId,
            Request.Parameter.lats : PreferenceManager.shared.lat ?? String(),
            Request.Parameter.longs: PreferenceManager.shared.long ?? String(),
            Request.Parameter.search: "",
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.home, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<[HomeModal]>.self, successBlock: { (response: ResponseModal<[HomeModal]>) in
                        
            self.isRequesting = false
            
            if response.code == Status.Code.success {
                
                delay {
                    
                    if self.lastRequestId.isEmpty {
                        self.items.removeAll()
                    }
                    
                    self.items.append(contentsOf: response.data ?? [])
                    self.items = self.items.removingDuplicates()
                    self.lastRequestId = response.data?.last?.golfID ?? String()
                    self.setupData()

                    for obj in response.data ?? [] {
                        self.setMarkers(lat: Double(obj.latitude ?? String()) ?? 0.0, Long: Double(obj.latitude ?? String()) ?? 0.0, clubName:obj.golfCourseName ?? String())
                    }
                    
                    completion?(true)
                }
            } else if response.code == Status.Code.notfound{
                        
                completion?(true)
                
            } else {
                
                completion?(true)
            }
            
            LoadingManager.shared.hideLoading()
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            self.isRequesting = false
            
            delay {
                
                DisplayAlertManager.shared.displayAlert(target: self, animated: false, message: error.localizedDescription) {
                    PreferenceManager.shared.userId = nil
                    PreferenceManager.shared.currentUser = nil
                    PreferenceManager.shared.authToken = nil
                    NavigationManager.shared.setupSingIn()
                }
            }
        })
    }
    
    func performGetBadgeCount(completion:((_ flag: Bool) -> Void)?) {
        
        let parameter: [String: Any] = [
            Request.Parameter.userID: PreferenceManager.shared.userId ?? String(),
            Request.Parameter.role: PreferenceManager.shared.curretMode ?? String(),
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.badgeCount, parameter: parameter, headers: [:], showLoader: false, decodingType: ResponseModal<BadgeModal>.self, successBlock: { (response: ResponseModal<BadgeModal>) in
                        
            self.isRequesting = false
            
            if response.code == Status.Code.success {
                
                if let stringUser = try? response.data?.jsonString() {
                    
                    PreferenceManager.shared.badgeModal = stringUser
                    
                    if response.data?.getNotificationCount == "0" {
                        
                        self.imgNotif.image = UIImage(named: FGImageName.notif)
                        
                    } else {
                        
                        self.imgNotif.image = UIImage(named: FGImageName.notif)
                        
                    }
                    
                }
                
            } else {
                
                completion?(true)
            }
            
            LoadingManager.shared.hideLoading()
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            self.isRequesting = false
            
//            delay {
//
//                DisplayAlertManager.shared.displayAlert(target: self, animated: false, message: error.localizedDescription) {
//                    PreferenceManager.shared.userId = nil
//                    PreferenceManager.shared.currentUser = nil
//                    PreferenceManager.shared.authToken = nil
//                    NavigationManager.shared.setupSingIn()
//                }
//            }
        })
    }
    
    //------------------------------------------------------
    
    //MARK: Set marker on mapview
    
    func setMarkers(lat :Double, Long : Double , clubName : String) {
        
//        locationsMap.addAnnotation(annotation)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
//        self.locationsMap.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = clubName
        let center = CLLocationCoordinate2D(latitude: lat, longitude: Long)
        annotation.coordinate = center
//        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: Long)
        self.locationsMap.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8))
        self.locationsMap.setRegion(region, animated: true)
        
    }
    
//    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last! as CLLocation
//        setMarkers(lat: Double(location.coordinate.latitude), Long: Double(location.coordinate.longitude))
//    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnNotificationTap(_ sender: UIButton) {
        let controller = NavigationManager.shared.notificationVC
        push(controller: controller)
    }
    
    @IBAction func btnPull(_ sender: UIButton) {
        PreferenceManager.shared.comesFromHomeListing = false
        bottomSheetView()
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        let controller = NavigationManager.shared.seachLocationVC
        push(controller: controller)
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.startMonitoring()
//        setMarkers(lat: Double(PreferenceManager.shared.lat ?? 0.0), Long: Double(PreferenceManager.shared.long ?? 0.0))
        imgMain.roundCornersLeft( [.topLeft, .bottomLeft],radius: 16)
        
        PreferenceManager.shared.isHost = "0"
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomSheetView()
        PreferenceManager.shared.comesFromConfirmToPay = "0"
        
        self.performGetNearByGolfClubs { (flag : Bool) in
            
        }
        
        self.performGetBadgeCount { (flag : Bool) in
            
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            self.setMarkers(lat: Double(PreferenceManager.shared.lat ?? 0.0), Long: Double(PreferenceManager.shared.long ?? 0.0))
//        }
        
        NavigationManager.shared.isEnabledBottomMenu = true
    }
}

