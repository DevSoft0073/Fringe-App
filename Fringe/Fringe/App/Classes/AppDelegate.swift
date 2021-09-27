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
import CoreLocation
import GoogleSignIn
import FBSDKCoreKit
import UserNotifications
import IQKeyboardManagerSwift

let signInConfig = GIDConfiguration.init(clientID: "929112962841-9qvjehvnruco3u9nfc7l4g27aeqmt3dc.apps.googleusercontent.com")

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate{
    
    var window: UIWindow?
    var locationManager: CLLocationManager!
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
            NavigationManager.shared.setupLandingOnHome()
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
    
    //------------------------------------------------------
    
    //MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureKeboard()
        getCustomFontDetails()
        configureNavigationBar()
        chekLoggedUser()
        FirebaseApp.configure()
        registerRemoteNotificaton(application)
        //RealmManager.shared.save(channelDownload: false)
        window?.tintColor = FGColor.appBlack
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
            } else {
                // Show the app's signed-in state.
            }
        }
                
        // stripe publishable key For live
        
        //        StripeAPI.defaultPublishableKey = "pk_test_51JUS7iJ3XoLMRYVnKpR01bRRdE11rfnPrp5HJQrC6aUcRZTrY911Vvj5z3QWTACUjt55diQLeresblgaCv2qdGoO00u4MzXpuN"
        
        // stripe publishable key For testing
        
        StripeAPI.defaultPublishableKey = "sk_test_51JUS7iJ3XoLMRYVne26o0RcRXQtMgliZktPIihg7TRR8rEqcIpa8USR9g6out0i593Vt5cSGmiivcNs0rbbb3fon00Az943rmZ"
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
