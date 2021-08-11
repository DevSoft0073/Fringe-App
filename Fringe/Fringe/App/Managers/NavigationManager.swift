//
//  NavigationManager.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//

import UIKit

struct PMStoryboard {
        
    public static let main: String = "Main"
    public static let loader: String = "Loader"
}

struct PMNavigation {
        
    public static let signInOption: String = "navigationSingInOption"
}

class NavigationManager: NSObject {
    
    let window = AppDelegate.shared.window
    
    //------------------------------------------------------
    
    //MARK: Storyboards
    
    let mainStoryboard = UIStoryboard(name: PMStoryboard.main, bundle: Bundle.main)
    let loaderStoryboard = UIStoryboard(name: PMStoryboard.loader, bundle: Bundle.main)
    
    //------------------------------------------------------
    
    //MARK: Shared
    
    static let shared = NavigationManager()
    
    //------------------------------------------------------
    
    //MARK: UINavigationController
       
    var signInOptionsNC: UINavigationController {
        return mainStoryboard.instantiateViewController(withIdentifier: PMNavigation.signInOption) as! UINavigationController
    }
    
    //------------------------------------------------------
    
    //MARK: RootViewController
    
    func setupSingInOption() {
        
        let controller = signInOptionsNC
        AppDelegate.shared.window?.rootViewController = controller
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewControllers
    
    public var loadingIndicatorVC: LoadingIndicatorVC {
        return loaderStoryboard.instantiateViewController(withIdentifier: String(describing: LoadingIndicatorVC.self)) as! LoadingIndicatorVC
    }
    
    /*public var signInOptionsVC: SignInOptionsVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: SignInOptionsVC.self)) as! SignInOptionsVC
    }*/
    
    //------------------------------------------------------
}
