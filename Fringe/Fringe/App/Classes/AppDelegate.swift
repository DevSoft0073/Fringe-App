//
//  AppDelegate.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//
//

import UIKit
import Stripe
import Firebase
import Alamofire
import GooglePlaces
import CoreLocation
import GoogleSignIn
import FBSDKCoreKit
import PayPalCheckout
import UserNotifications
import IQKeyboardManagerSwift
import GoogleMaps

let signInConfig = GIDConfiguration.init(clientID: "929112962841-9qvjehvnruco3u9nfc7l4g27aeqmt3dc.apps.googleusercontent.com")

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate{
    
    var window: UIWindow?
    var locationManager: CLLocationManager!
    let GOOGLE_API_KEY = "AIzaSyBHGK2nRDFJW6FfJWWe1-h-oCEb3dGgw1c"
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    /// keyboard configutation
    private func configureKeboard() {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarTintColor = FGColor.appBlack
        IQKeyboardManager.shared.enableAutoToolbar = true
        //        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [ChatDetailsVC.self, ChatViewController.self]
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses = [UIScrollView.self,UIView.self,UITextField.self,UITextView.self,UIStackView.self]
        
    }
    
    /// to get custom added font names
    private func getCustomFontDetails() {
        #if DEBUG
        for family in UIFont.familyNames {
            let sName: String = family as String
            debugPrint("family: \(sName)")
            for name in UIFont.fontNames(forFamilyName: sName) {
                debugPrint("name: \(name as String)")
            }
        }
        #endif
    }
    
    public func configureNavigationBar() {
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = FGColor.appBlack
            appearance.titleTextAttributes = [.foregroundColor: FGColor.appBlack, .font: FGFont.PoppinsRegular(size: FGFont.defaultRegularFontSize)]
            appearance.largeTitleTextAttributes = [.foregroundColor: FGColor.appBlack, .font: FGFont.PoppinsRegular(size: FGFont.defaultRegularFontSize)]
            
            UINavigationBar.appearance().barTintColor = FGColor.appBlack
            UINavigationBar.appearance().tintColor = FGColor.appBlack
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().barTintColor = FGColor.appBlack
            UINavigationBar.appearance().tintColor = FGColor.appBlack
            UINavigationBar.appearance().isTranslucent = false
        }
    }
    
    func registerRemoteNotificaton(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
        } else {
            
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    func chekLoggedUser() {
        
        if PreferenceManager.shared.loggedUser == true {
            
            PreferenceManager.shared.comesFromHomeListing = false
            
            if PreferenceManager.shared.curretMode == "1"{
                
                NavigationManager.shared.setupLandingOnHome()
                
            } else {
                                
                NavigationManager.shared.setupLandingOnHomeForHost()
            }
            
        } else {
            
            NavigationManager.shared.setupSingIn()
        }
    }
    
    func performUpdateLocation(lat : String , long : String ,completion:((_ flag: Bool) -> Void)?) {
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        let parameter: [String: Any] = [
            Request.Parameter.lat: lat,
            Request.Parameter.long: long,
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.updateLocation, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<UserModal>.self, successBlock: { (response: ResponseModal<UserModal>) in
            
            if response.code == Status.Code.success {
                
                if let stringUser = try? response.data?.jsonString() {
                    print(stringUser)
                }
                
                delay {
                    
                    completion?(true)
                    
                }
                
            } else {
                
                completion?(false)
                
                delay {
                    
                }
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
            completion?(false)
            
            LoadingManager.shared.hideLoading()
            
            delay {
                
            }
        })
    }
    
    func paypalConfigure(){
        let config = CheckoutConfig(
            clientID: "AYsdFF0ak5ao3XUxchpR6OTc_JtPMI0IpElD7YR8xBfQZ_o6IkJYWL7ebsMaoyNcAQ1ZVM2--cYrw1JY",
            returnUrl: "com.ipa.app://paypalpay",
            environment: .sandbox
        )
        
        Checkout.set(config: config)
    }
    
    func setupSocket() {
        
        let socketConnectionStatus = SocketManger.shared.socket.status
        switch socketConnectionStatus {
        case .connected:
            debugPrint("socket connected")
        case .connecting:
            debugPrint("socket connecting")
        case .disconnected:
            debugPrint("socket disconnected")
            debugPrint("socket not connected")
            SocketManger.shared.socket.connect()
        case .notConnected:
            debugPrint("socket not connected")
            SocketManger.shared.socket.connect()
        }
    }
    
    func handleRemoteNotification(userInfo: [AnyHashable: Any], completion: @escaping(_ flag: Bool) -> Void ) {
        debugPrint("handleRemoteNotification:\(userInfo as? [String:Any] ?? [:])")
        completion(true)
        if PreferenceManager.shared.currentUser != nil {
            print(userInfo)
            if let apsData = userInfo["aps"] as? [String:Any] {
                if let data = apsData["data"] as? [String:Any]{
                    let type = data["notification_type"]
                    if type as? String ?? "0" == "1" {
                        if PreferenceManager.shared.curretMode == "1"{
                            NavigationManager.shared.setupLandingOnChatVC(roomID: data["room_id"] as? String ?? "", image: data["image"] as? String ?? "", otherUserImage: data["otheruserImage"] as? String ?? "", name: data["user_name"] as? String ?? "")
                        } else {
                            NavigationManager.shared.setupLandingOnChatVCForHost(roomID: data["room_id"] as? String ?? "", image: data["image"] as? String ?? "", otherUserImage: data["otheruserImage"] as? String ?? "", name: data["user_name"] as? String ?? "")
                        }
                    } else if type as? String ?? "0" == "2" {
                        
                        NavigationManager.shared.setupLandingOnprofileVC()
                        
                    } else if type as? String ?? "0" == "3" {
                        
                    } else if type as? String ?? "0" == "4" {
                        
                    }
                }
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        handleRemoteNotification(userInfo: response.notification.request.content.userInfo) { (flag) in
            completionHandler()
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureKeboard()
        getCustomFontDetails()
        configureNavigationBar()
        chekLoggedUser()
        FirebaseApp.configure()
        paypalConfigure()
        registerRemoteNotificaton(application)
        GMSPlacesClient.provideAPIKey(GOOGLE_API_KEY)
        GMSServices.provideAPIKey(GOOGLE_API_KEY)
        window?.tintColor = FGColor.appBlack
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
            } else {
                // Show the app's signed-in state.
            }
        }
                
        // stripe publishable key For live
        
        
        
        // stripe publishable key For testing
        
        StripeAPI.defaultPublishableKey = "pk_test_51JUS7iJ3XoLMRYVnKpR01bRRdE11rfnPrp5HJQrC6aUcRZTrY911Vvj5z3QWTACUjt55diQLeresblgaCv2qdGoO00u4MzXpuN"
      
//       // StripeAPI.defaultPublishableKey = "sk_test_51JnMWiEUY9QNmfGAcfuzKLKVeP42VKanJAMli6RPtMuFY5rjC3AyaM5EkKGFw0OHzKOxgRK78qVzyS8kJn84TrK400ikDZia8n"
//
//        StripeAPI.defaultPublishableKey = "sk_test_51JUS7iJ3XoLMRYVne26o0RcRXQtMgliZktPIihg7TRR8rEqcIpa8USR9g6out0i593Vt5cSGmiivcNs0rbbb3fon00Az943rmZ"
//
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.setupSocket()
        }
        
        return true
    }
    
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        PreferenceManager.shared.lat = location.coordinate.latitude
        PreferenceManager.shared.long = location.coordinate.longitude
    }
    
    func application(_ app: UIApplication,open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return .portrait
    }
    
    //------------------------------------------------------
    
    //MARK: UNUserNotificationCenterDelegate
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.hexString
        PreferenceManager.shared.deviceToken = deviceTokenString
        //        NavigationManager.shared.setupLanding()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("didFailToRegisterForRemoteNotificationsWithError: \(error.localizedDescription)")
        DisplayAlertManager.shared.displayAlert(animated: true, message: error.localizedDescription, handlerOK: nil)
//        NavigationManager.shared.setupLanding()
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound])
//    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
