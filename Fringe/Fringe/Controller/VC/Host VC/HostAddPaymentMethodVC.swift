//
//  HostAddPaymentMethodVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 31/08/21.
//

import UIKit
import Foundation

class HostAddPaymentMethodVC : BaseVC {
    
    @IBOutlet weak var lblAccountNumber: FGBaseLabel!
    @IBOutlet weak var lblName: FGBaseLabel!
    @IBOutlet weak var lblRoutingNumber: FGBaseLabel!
    @IBOutlet weak var lblSSN: FGBaseLabel!
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
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
        
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        let controller = NavigationManager.shared.businessAddPaymentMethodVC
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
    }
    
    //------------------------------------------------------
}
