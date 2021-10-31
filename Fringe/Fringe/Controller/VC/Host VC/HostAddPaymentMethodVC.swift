//
//  HostAddPaymentMethodVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 31/08/21.
//

import UIKit
import Foundation

class HostAddPaymentMethodVC : BaseVC {
    
    @IBOutlet weak var noDataLbl: FGSemiboldLabel!
    @IBOutlet weak var paymentView: UIView!
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
        
        if currentUserHost?.accountNumber == " " {
            noDataLbl.isHidden = false
            paymentView.isHidden = true
            imgEdit.isHidden = false
            btnEdit.isUserInteractionEnabled = true
            
        } else {
            imgEdit.isHidden = true
            btnEdit.isUserInteractionEnabled = false
            noDataLbl.isHidden = true
            paymentView.isHidden = false
            lblSSN.text = currentUserHost?.ssnLast4
            lblAccountNumber.text = currentUserHost?.accountNumber
            lblName.text = currentUserHost?.accountHolderName
            lblRoutingNumber.text = currentUserHost?.routingNumber
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        
        if PreferenceManager.shared.comesFromPopUpView == true {
            
            NavigationManager.shared.setupLandingOnHomeForHost()
            
        }else {
            
            self.pop()
            
        }
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        let controller = NavigationManager.shared.businessAddPaymentMethodVC
        push(controller: controller)
        
    }
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if currentUserHost?.stripeAccountStatus == "1" {
            btnEdit.isHidden = true
            imgEdit.isHidden = true
        }
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        NavigationManager.shared.isEnabledBottomMenuForHost = false
    }
    
    //------------------------------------------------------
}
