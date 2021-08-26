//
//  AccountInformationVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 18/08/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class AccountInformationVC : BaseVC {
    
    @IBOutlet weak var lblName: FGBaseLabel!
    @IBOutlet weak var lblEmail: FGBaseLabel!
    @IBOutlet weak var lblDateOfBirth: FGBaseLabel!
    @IBOutlet weak var lblMobileNumber: FGBaseLabel!
    @IBOutlet weak var lblPassword: FGBaseLabel!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var textTitle: String?
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    
    //------------------------------------------------------
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationManager.shared.isEnabledBottomMenu = false
    }
    
    //------------------------------------------------------
}
