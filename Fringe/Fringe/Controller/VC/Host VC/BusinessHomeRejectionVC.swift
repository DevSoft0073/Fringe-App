//
//  BusinessHomeRejectionVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 30/08/21.
//

import UIKit
import Foundation

class BusinessHomeRejectionVC : BaseVC {
    

    @IBOutlet weak var btnCancel: FGActiveButton!
    @IBOutlet weak var btnReject: FGActiveButton!
    @IBOutlet weak var reasonTextView: FGRegularTextView!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var popUpView: UIView!
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
    
    @IBAction func btnReject(_ sender: Any) {
    }
    
    @IBAction func btnCancel(_ sender: Any) {
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
