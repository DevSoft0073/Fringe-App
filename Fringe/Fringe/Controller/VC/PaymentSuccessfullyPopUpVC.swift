//
//  PaymentSuccessfullyPopUpVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 02/09/21.
//
import UIKit
import Foundation

class PaymentSuccessfullyPopUpVC : BaseVC {
    
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var popView: UIView!
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
    
    @IBAction func btnOkay(_ sender: Any) {
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
