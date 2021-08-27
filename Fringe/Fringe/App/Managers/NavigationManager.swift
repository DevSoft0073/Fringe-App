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

class NavigationManager: NSObject, UITabBarControllerDelegate {
    
    let window = AppDelegate.shared.window
    private var tabbarController: ESTabBarController?
    private var tabbarControllerForHost: ESTabBarController?

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
    
    //MARK: UITabbarController
    
    public func customIrregularityStyleForHost(delegate: UITabBarControllerDelegate?) -> ESTabBarController {
        
        let tabBarControllerForHost = ESTabBarController()
        tabBarControllerForHost.delegate = delegate
        tabBarControllerForHost.tabBar.shadowImage = UIImage(named: FGImageName.icontransparent)
        tabBarControllerForHost.tabBar.shadowColor = UIColor.darkGray
        tabBarControllerForHost.tabBar.shadowOffset = CGSize.zero
        tabBarControllerForHost.tabBar.shadowOpacity = 0.7
        tabBarControllerForHost.tabBar.isTranslucent = true
        tabBarControllerForHost.tabBar.barTintColor = FGColor.appBackground
        
        let v1 = golfclubsNC
        let v2 = homeNC
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
        
        tabBarControllerForHost.viewControllers = [v1, v2, v3, v4, v5]
        
        return tabBarControllerForHost
    }
    
    
    
    var landingTC: ESTabBarController {
        return customIrregularityStyle(delegate: self)
    }
    
    var landingTCForHost: ESTabBarController {
        return customIrregularityStyle(delegate: self)
    }
    
    public var isEnabledBottomMenu: Bool = false {
        didSet {
            self.tabbarController?.tabBar.isHidden = !isEnabledBottomMenu
        }
    }
    
    public var isEnabledBottomMenuForHost: Bool = false {
        didSet {
            self.tabbarControllerForHost?.tabBar.isHidden = !isEnabledBottomMenu
        }
    }
    
    
    //------------------------------------------------------
    
    //MARK: RootViewController
    
    func setupSingIn() {
        AppDelegate.shared.window?.rootViewController = signInNC
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    func setupLandingOnHome() {
        
        tabbarController = landingTC
        AppDelegate.shared.window?.rootViewController = tabbarController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    func setupLandingOnHomeForHost() {
        tabbarControllerForHost = landingTCForHost
        AppDelegate.shared.window?.rootViewController = tabbarControllerForHost
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
    public var changePasswordVC: ChangePasswordVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: ChangePasswordVC.self)) as! ChangePasswordVC
    }
    public var addPaymentMethodVC: AddPaymentMethodVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: AddPaymentMethodVC.self)) as! AddPaymentMethodVC
    }
    public var myBookingVC: MyBookingVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: MyBookingVC.self)) as! MyBookingVC
    }
    public var addPaymentVC: AddPaymentVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: AddPaymentVC.self)) as! AddPaymentVC
    }
    public var detailsScreenVC: DetailsScreenVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: DetailsScreenVC.self)) as! DetailsScreenVC
    }
    public var checkAvailabilityVC: CheckAvailabilityVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: CheckAvailabilityVC.self)) as! CheckAvailabilityVC
    }
    
    public var signUpHostVC: SignUpHostVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: SignUpHostVC.self)) as! SignUpHostVC
    }
    
    public var confirmedPayVC: ConfirmedPayVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: ConfirmedPayVC.self)) as! ConfirmedPayVC
    }
    public var searchVC: SearchVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: SearchVC.self)) as! SearchVC
    }
 
    public var homeListingVC: HomeListingVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: HomeListingVC.self)) as! HomeListingVC
    }
    
    public var bookingDetailsVC: BookingDetailsVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: BookingDetailsVC.self)) as! BookingDetailsVC
    }
    
    public var bookingDetailsRatingVC: BookingDetailsRatingVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: BookingDetailsRatingVC.self)) as! BookingDetailsRatingVC
    }
    
    public var privacyVC : PrivacyVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: PrivacyVC.self)) as! PrivacyVC
    }
    
    public var serviceTermsVC : ServiceTermsVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: ServiceTermsVC.self)) as! ServiceTermsVC
    }
    
}

