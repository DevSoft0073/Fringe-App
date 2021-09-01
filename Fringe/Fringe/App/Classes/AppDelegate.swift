//
//  AppDelegate.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//
//

import UIKit
import IQKeyboardManagerSwift
import UIKit
import FBSDKCoreKit
import UserNotifications

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
       // IQKeyboardManager.shared.disabledDistanceHandlingClasses = [ChatDetailsVC.self, ChatViewController.self]
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
    
//    func chekLoggedUser() {
//        if PreferenceManager.shared.loggedUser == true {
//            NavigationManager.shared.setupLandingOnHome()
//        } else {
//            NavigationManager.shared.setupSingIn()
//        }
//    }
    
    
    //------------------------------------------------------
    
    //MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureKeboard()
        getCustomFontDetails()
        configureNavigationBar()
//        chekLoggedUser()
        //RealmManager.shared.save(channelDownload: false)
        window?.tintColor = FGColor.appBlack
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return .portrait
    }
    
    //------------------------------------------------------
}
