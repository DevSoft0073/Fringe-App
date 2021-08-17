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

class NavigationManager: NSObject ,UITabBarControllerDelegate {
    
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
//        tabBarController.tabBar.shadowImage = UIImage(named: FGImageName.icontransparent)
        tabBarController.tabBar.shadowColor = UIColor.clear
        tabBarController.tabBar.shadowOffset = CGSize.zero
        tabBarController.tabBar.shadowOpacity = 0.7
        tabBarController.tabBar.isTranslucent = true
        //tabBarController.tabBar.backgroundColor = UIColor.white
        tabBarController.tabBar.barTintColor = FGColor.appBorder
        //tabBarController.tabBar.backgroundImage = UIImage(named: TFImageName.iconDarkBackground)
        
        let v1 = homeNC
        let v2 = golfclubsNC
        let v3 = favouriteNC
        let v4 = inboxNC
        let v5 = profileNC
    
        v1.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "Home", image: UIImage(named: FGImageName.iconhomeunsel), selectedImage: UIImage(named: FGImageName.iconhomesel))
        v2.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "GolfClubs", image: UIImage(named: FGImageName.icongolfunsel), selectedImage: UIImage(named:FGImageName.icongolfsel))
        v3.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "Favorite", image: UIImage(named: FGImageName.iconfavouriteunsel), selectedImage: UIImage(named:FGImageName.iconfavouritesel))
        v4.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "Inbox", image: UIImage(named: FGImageName.iconinboxunsel), selectedImage: UIImage(named: FGImageName.iconinboxsel))
        v5.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "Profile", image: UIImage(systemName: FGImageName.iconprofileunsel), selectedImage: UIImage(named: FGImageName.iconprofilesel))
        
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
    
    func setupSignIn() {
        
        AppDelegate.shared.window?.rootViewController = signInNC
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    func setupLanding(_ isFromRemoteNotification: Bool = false) {
        
        //locally save controller to set their properties
        tabbarController = landingTC
        AppDelegate.shared.window?.rootViewController = tabbarController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    func setupGuest() {
        
        AppDelegate.shared.window?.rootViewController = self.golfclubsNC
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

    
    
    /*public var signInOptionsVC: SignInOptionsVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: SignInOptionsVC.self)) as! SignInOptionsVC
    }*/
    
    //------------------------------------------------------
}
