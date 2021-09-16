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

class HomeVC : BaseVC, FGLocationManagerDelegate{
    
    
    @IBOutlet weak var locationsMap: MKMapView!
    @IBOutlet weak var lblPrice: FGMediumLabel!
    @IBOutlet weak var lblRating: FGRegularLabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblAddress: FGRegularLabel!
    @IBOutlet weak var imgFavUnfav: UIImageView!
    @IBOutlet weak var lblName: FGSemiboldLabel!
    @IBOutlet weak var imgMain: UIImageView!
    
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
        let controller = HomeListingVC.instantiate()
        var sizes = [SheetSize]()
        sizes.append(.fixed(UIScreen.main.bounds.size.height * 0.5))
        sizes.append(.marginFromTop(60))
        let sheetController = SheetViewController(controller: controller, sizes: sizes)
        self.present(sheetController, animated: true, completion: nil)
    }
    
    //------------------------------------------------------
    
    //MARK: Set marker on mapview
    
    func setMarkers(lat :Double, Long : Double) {
        let center = CLLocationCoordinate2D(latitude: lat, longitude: Long)
        annotation.coordinate = center
        locationsMap.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.12, longitudeDelta: 0.12))
        self.locationsMap.setRegion(region, animated: true)
        
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnSearch(_ sender: UIButton) {
        let controller = NavigationManager.shared.clubSearchVC
        push(controller: controller)
    }
    
    @IBAction func btnNotificationTap(_ sender: UIButton) {
        let controller = NavigationManager.shared.notificationVC
        push(controller: controller)
    }
    
    @IBAction func btnPull(_ sender: UIButton) {
        bottomSheetView()
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.startMonitoring()
//        fatalError()
        imgMain.roundCornersLeft( [.topLeft, .bottomLeft],radius: 16)
       
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMarkers(lat: Double(PreferenceManager.shared.lat ?? 0.0), Long: Double(PreferenceManager.shared.long ?? 0.0))
        NavigationManager.shared.isEnabledBottomMenu = true
    }
}

