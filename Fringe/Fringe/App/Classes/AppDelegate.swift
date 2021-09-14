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
import GoogleSignIn
import UserNotifications
import IQKeyboardManagerSwift

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{
    
    var window: UIWindow?
    
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
    
    
    //------------------------------------------------------
    
    //MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureKeboard()
        getCustomFontDetails()
        configureNavigationBar()
        chekLoggedUser()
        registerRemoteNotificaton(application)
        //RealmManager.shared.save(channelDownload: false)
        window?.tintColor = FGColor.appBlack
        
        
        // stripe publishable key For live
        
        //        StripeAPI.defaultPublishableKey = "pk_test_51JUS7iJ3XoLMRYVnKpR01bRRdE11rfnPrp5HJQrC6aUcRZTrY911Vvj5z3QWTACUjt55diQLeresblgaCv2qdGoO00u4MzXpuN"
        
        // stripe publishable key For testing
        
        StripeAPI.defaultPublishableKey = "sk_test_51JUS7iJ3XoLMRYVne26o0RcRXQtMgliZktPIihg7TRR8rEqcIpa8USR9g6out0i593Vt5cSGmiivcNs0rbbb3fon00Az943rmZ"
        
        return true
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
        //DisplayAlertManager.shared.displayAlert(animated: true, message: error.localizedDescription, handlerOK: nil)
        //        NavigationManager.shared.setupLanding()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    //------------------------------------------------------
}
