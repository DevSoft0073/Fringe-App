//
//  NavigationManager.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//

import UIKit

struct FGStoryboard {
    
    public static let main: String = "Main"
    public static let loader: String = "Loader"
}

struct FGNavigation {
    
    public static let signIn: String = "navigationSingIn"
    public static let landing: String = "tabbarLanding"
    public static let home: String = "navigationHome"
    public static let golfclubs: String = "navigationGolfclub"
    public static let favourite: String = "navigationFavourite"
    public static let inbox: String = "navigationInbox"
    public static let profile: String = "navigationProfile"
    
    //Location search
    public static let locationSearch: String = "navigationLocationSearchVC"
}

//class NavigationManager: NSObject ,UITabBarControllerDelegate {
//
//    let window = AppDelegate.shared.window
//    private var tabbarController: ESTabBarController?
//
//    //------------------------------------------------------
//
//    //MARK: Storyboards
//
//    let mainStoryboard = UIStoryboard(name: FGStoryboard.main, bundle: Bundle.main)
//    let loaderStoryboard = UIStoryboard(name: FGStoryboard.loader, bundle: Bundle.main)
//
//    //------------------------------------------------------
//
//    //MARK: Shared
//
//    static let shared = NavigationManager()
//
//    //------------------------------------------------------
//
//    //MARK: UINavigationController
//
//    var signInNC: UINavigationController {
//        return mainStoryboard.instantiateViewController(withIdentifier: FGNavigation.signIn) as! UINavigationController
//    }
//
//    var homeNC: UINavigationController {
//        return mainStoryboard.instantiateViewController(withIdentifier: FGNavigation.home) as! UINavigationController
//    }
//
//    var golfclubsNC: UINavigationController {
//        return mainStoryboard.instantiateViewController(withIdentifier: FGNavigation.golfclubs) as! UINavigationController
//    }
//    var favouriteNC: UINavigationController {
//        return mainStoryboard.instantiateViewController(withIdentifier: FGNavigation.favourite) as! UINavigationController
//    }
//
//    var inboxNC: UINavigationController {
//        return mainStoryboard.instantiateViewController(withIdentifier: FGNavigation.inbox) as! UINavigationController
//    }
//
//    var profileNC: UINavigationController {
//        return mainStoryboard.instantiateViewController(withIdentifier: FGNavigation.profile) as! UINavigationController
//    }
//
//    //------------------------------------------------------
//
//    //MARK: UITabbarController
//
//    public func customIrregularityStyle(delegate: UITabBarControllerDelegate?) -> ESTabBarController {
//
//        let tabBarController = ESTabBarController()
//        tabBarController.delegate = delegate
////        tabBarController.tabBar.shadowImage = UIImage(named: FGImageName.icontransparent)
//        tabBarController.tabBar.shadowColor = UIColor.clear
//        tabBarController.tabBar.shadowOffset = CGSize.zero
//        tabBarController.tabBar.shadowOpacity = 0.7
//        tabBarController.tabBar.isTranslucent = true
//        //tabBarController.tabBar.backgroundColor = UIColor.white
//        tabBarController.tabBar.barTintColor = FGColor.appBorder
//        //tabBarController.tabBar.backgroundImage = UIImage(named: TFImageName.iconDarkBackground)
//
//        let v1 = homeNC
//        let v2 = golfclubsNC
//        let v3 = favouriteNC
//        let v4 = inboxNC
//        let v5 = profileNC
//
//        v1.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "Home", image: UIImage(named: FGImageName.iconhomeunsel), selectedImage: UIImage(named: FGImageName.iconhomesel))
//        v2.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "GolfClubs", image: UIImage(named: FGImageName.icongolfunsel), selectedImage: UIImage(named:FGImageName.icongolfsel))
//        v3.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "Favorite", image: UIImage(named: FGImageName.iconfavouriteunsel), selectedImage: UIImage(named:FGImageName.iconfavouritesel))
//        v4.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "Inbox", image: UIImage(named: FGImageName.iconinboxunsel), selectedImage: UIImage(named: FGImageName.iconinboxsel))
//        v5.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "Profile", image: UIImage(systemName: FGImageName.iconprofileunsel), selectedImage: UIImage(named: FGImageName.iconprofilesel))
//
//        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
//
//        return tabBarController
//
//    }
//    var landingTC: ESTabBarController {
//        //return mainStoryboard.instantiateViewController(withIdentifier: PMNavigation.landing) as! UITabBarController
//        return customIrregularityStyle(delegate: self)
//    }
//
//    public var isEnabledBottomMenu: Bool = false {
//        didSet {
//            self.tabbarController?.tabBar.isHidden = !isEnabledBottomMenu
//        }
//    }
//
//
//    //------------------------------------------------------
//
//    //MARK: RootViewController
//
//    func setupSignIn() {
//
//        AppDelegate.shared.window?.rootViewController = signInNC
//        AppDelegate.shared.window?.makeKeyAndVisible()
//    }
//
//    func setupLanding(_ isFromRemoteNotification: Bool = false) {
//
//        //locally save controller to set their properties
//        tabbarController = landingTC
//        AppDelegate.shared.window?.rootViewController = tabbarController
//        AppDelegate.shared.window?.makeKeyAndVisible()
//    }
//
//    func setupGuest() {
//
//        AppDelegate.shared.window?.rootViewController = self.golfclubsNC
//        AppDelegate.shared.window?.makeKeyAndVisible()
//    }
//
//    //------------------------------------------------------
//
//    //MARK: UIViewControllers
//
//    public var loadingIndicatorVC: LoadingIndicatorVC {
//        return loaderStoryboard.instantiateViewController(withIdentifier: String(describing: LoadingIndicatorVC.self)) as! LoadingIndicatorVC
//    }
//    public var logInVC: LogInVC {
//        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: LogInVC.self)) as! LogInVC
//    }
//    public var signUpVC: SignUpVC {
//        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: SignUpVC.self)) as! SignUpVC
//    }
//
//    public var forgotPasswordVC: ForgotPasswordVC {
//        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: ForgotPasswordVC.self)) as! ForgotPasswordVC
//    }
//    public var notificationVC: NotificationVC {
//        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: NotificationVC.self)) as! NotificationVC
//    }
//
//
//
//    /*public var signInOptionsVC: SignInOptionsVC {
//        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: SignInOptionsVC.self)) as! SignInOptionsVC
//    }*/
//
//    //------------------------------------------------------
//}

class NavigationManager: NSObject, UITabBarControllerDelegate {
    
    let window = AppDelegate.shared.window
    private var tabbarController: ESTabBarController?
    
    //------------------------------------------------------
    
    //MARK: Storyboards
    
    let mainStoryboard = UIStoryboard(name: FGStoryboard.main, bundle: Bundle.main)
    let loaderStoryboard = UIStoryboard(name: FGStoryboard.loader, bundle: Bundle.main)
    
    //------------------------------------------------------
    
    //MARK: Shared
    
    static let shared = NavigationManager()
    
    //------------------------------------------------------
    
    //    MARK: UINavigationController
    
    //------------------------------------------------------
    
    //MARK: UINavigationController
    
    var signInNC: UINavigationController {
        return mainStoryboard.instantiateViewController(withIdentifier: FGNavigation.signIn) as! UINavigationController
    }
    
    var homeNC: UINavigationController {
        return mainStoryboard.instantiateViewController(withIdentifier: FGNavigation.home) as! UINavigationController
    }
    
    var golfclubsNC: UINavigationController {
        return mainStoryboard.instantiateViewController(withIdentifier: FGNavigation.golfclubs) as! UINavigationController
    }
    var favouriteNC: UINavigationController {
        return mainStoryboard.instantiateViewController(withIdentifier: FGNavigation.favourite) as! UINavigationController
    }
    
    var inboxNC: UINavigationController {
        return mainStoryboard.instantiateViewController(withIdentifier: FGNavigation.inbox) as! UINavigationController
    }
    
    var profileNC: UINavigationController {
        return mainStoryboard.instantiateViewController(withIdentifier: FGNavigation.profile) as! UINavigationController
    }
    
    //------------------------------------------------------
    
    //MARK: UITabbarController
    
    public func customIrregularityStyle(delegate: UITabBarControllerDelegate?) -> ESTabBarController {
        
        let tabBarController = ESTabBarController()
        tabBarController.delegate = delegate
        tabBarController.tabBar.shadowImage = UIImage(named: FGImageName.icontransparent)
        tabBarController.tabBar.shadowColor = UIColor.darkGray
        tabBarController.tabBar.shadowOffset = CGSize.zero
        tabBarController.tabBar.shadowOpacity = 0.7
        tabBarController.tabBar.isTranslucent = true
        //tabBarController.tabBar.backgroundColor = UIColor.white
        tabBarController.tabBar.barTintColor = FGColor.appBackground
        //tabBarController.tabBar.backgroundImage = UIImage(named: TFImageName.iconDarkBackground)
        
        let v1 = homeNC
        let v2 = golfclubsNC
        let v3 = favouriteNC
        let v4 = inboxNC
        let v5 = profileNC
        
        /*tabBarController.shouldHijackHandler = {
         tabbarController, viewController, index in
         if index == 2 {
         return true
         }
         return false
         }
         
         tabBarController.didHijackHandler = {
         [weak tabBarController] tabbarController, viewController, index in
         
         let v3 = self.addNC
         v3.modalPresentationStyle = .fullScreen
         tabBarController?.present(v3, animated: true, completion: nil)
         }*/
        
        v1.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "Home", image: UIImage(named: FGImageName.iconHomeUnselected), selectedImage: UIImage(named: FGImageName.iconHomeSelected))
        v2.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "Golfclubs", image: UIImage(named: FGImageName.iconGolfUnselected), selectedImage: UIImage(named: FGImageName.iconGolfSelected))
        v3.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "Favourites", image: UIImage(named: FGImageName.iconFavouriteUnselected), selectedImage: UIImage(named: FGImageName.iconFavouriteSelected))
        v4.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "Inbox", image: UIImage(named: FGImageName.iconInboxUnselected), selectedImage: UIImage(named: FGImageName.iconInboxSelected))
        v5.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "Profile", image: UIImage(named: FGImageName.iconProfileUnselected), selectedImage: UIImage(named: FGImageName.iconProfileSelected))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        return tabBarController
    }
    
    
    
    var landingTC: ESTabBarController {
        //return mainStoryboard.instantiateViewController(withIdentifier: PMNavigation.landing) as! UITabBarController
        return customIrregularityStyle(delegate: self)
    }
    
    public var isEnabledBottomMenu: Bool = false {
        didSet {
            self.tabbarController?.tabBar.isHidden = !isEnabledBottomMenu
        }
    }
    
    
    //------------------------------------------------------
    
    //MARK: RootViewController
    
    func setupSingIn() {
        AppDelegate.shared.window?.rootViewController = signInNC
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    //    func setupPermission() {
    //
    //        //1. check notification permission
    //        AppDelegate.shared.isRequiredToShowNotificationPermissionDialogue { (flag: Bool) in
    //
    //            var permissions: [Permissions] = []
    //
    //            let isRequiredToShowNotificationPermissionDialogue = flag
    //
    //            //2. check if location permission is ON
    //            let isRequiredToShowPermissionDialogue = SCLocationManager.shared.isRequiredToShowPermissionDialogue()
    //
    //            if isRequiredToShowPermissionDialogue {
    //                permissions.append(.location)
    //            }
    //
    //            if isRequiredToShowNotificationPermissionDialogue {
    //                permissions.append(.notification)
    //            }
    //
    //            if permissions.count > 0 {
    //                let permissionNC = self.permissionNC
    //                if let permissionVC = permissionNC.viewControllers.first as? PermissionsVC {
    //                    permissionVC.permissions = permissions
    //                }
    //                AppDelegate.shared.window?.rootViewController = permissionNC
    //                AppDelegate.shared.window?.makeKeyAndVisible()
    //            } else {
    //                if PreferenceManager.shared.isStudioSignIn {
    //                    NavigationManager.shared.setupLandingForStudioProfile()
    //                } else {
    //                    NavigationManager.shared.setupLanding()
    //                }
    //            }
    //        }
    //    }
    //
    func setupLanding(_ isFromRemoteNotification: Bool = false) {
        
        //locally save controller to set their properties
        tabbarController = landingTC
        AppDelegate.shared.window?.rootViewController = tabbarController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    func setupLandingForSessionVC(_ isFromRemoteNotification: Bool = false , userID  : String , studioID : String) {
        
        tabbarController = landingTC
        tabbarController?.selectedIndex = 1
        AppDelegate.shared.window?.rootViewController = tabbarController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    func setupLandingForSessionVC() {
        
        tabbarController = landingTC
        tabbarController?.selectedIndex = 1
        AppDelegate.shared.window?.rootViewController = tabbarController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    func setupLandingForChatForArt() {
        
        tabbarController = landingTC
        tabbarController?.selectedIndex = 2
        AppDelegate.shared.window?.rootViewController = tabbarController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    func setupLandingForProfileVC(_ isFromRemoteNotification: Bool = false , userID  : String , studioID : String) {
        
        tabbarController = landingTC
        tabbarController?.selectedIndex = 4
        AppDelegate.shared.window?.rootViewController = tabbarController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    func setupGuest() {
        
        AppDelegate.shared.window?.rootViewController = self.homeNC
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewControllers
    
    public var loadingIndicatorVC: LoadingIndicatorVC {
        return loaderStoryboard.instantiateViewController(withIdentifier: String(describing: LoadingIndicatorVC.self)) as! LoadingIndicatorVC
    }
    
    public var logInVC: LogInVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: LogInVC.self)) as! LogInVC
    }
    
    public var signUpVC: SignUpVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: SignUpVC.self)) as! SignUpVC
    }
    
    public var forgotPasswordVC: ForgotPasswordVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: ForgotPasswordVC.self)) as! ForgotPasswordVC
    }
    public var notificationVC: NotificationVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: NotificationVC.self)) as! NotificationVC
    }
    public var editProfileVC: EditProfileVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: EditProfileVC.self)) as! EditProfileVC
    }
    public var accountInformationVC: AccountInformationVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: AccountInformationVC.self)) as! AccountInformationVC
    }
    
    
    
    /*public var signInOptionsVC: SignInOptionsVC {
     return mainStoryboard.instantiateViewController(withIdentifier: String(describing: SignInOptionsVC.self)) as! SignInOptionsVC
     }*/
    
    //------------------------------------------------------
}
