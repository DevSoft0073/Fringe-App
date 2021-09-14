//
//  HostAddPaymentMethodVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 31/08/21.
//

import UIKit
import Foundation

class HostAddPaymentMethodVC : BaseVC {
    
    @IBOutlet weak var imgEdit: UIImageView!
    @IBOutlet weak var btnEdit: UIButton!
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
    
    //MARK: Custome
    
    func setupUI()  {
        
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
        if currentUserHost?.customerID == "0" {
            btnEdit.isHidden = false
            imgEdit.isHidden = false
        }
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationManager.shared.isEnabledBottomMenuForHost = false
    }
    
    //------------------------------------------------------
}
