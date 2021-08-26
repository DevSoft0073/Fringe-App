//
//  HomeVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 12/08/21.
//

import UIKit
import Foundation

class HomeVC : BaseVC {
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    
    
    //------------------------------------------------------
    //MARK: Actions
    @IBAction func btnSearch(_ sender: Any) {
        let controller = NavigationManager.shared.homeListingVC
        push(controller: controller)
    }
    
    @IBAction func btnNotificationTap(_ sender: Any) {
        let controller = NavigationManager.shared.notificationVC
        push(controller: controller)
    }
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationManager.shared.isEnabledBottomMenu = true
        
    }
    
}
