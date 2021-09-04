//
//  AddCalendarPopUpVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 31/08/21.
//
import UIKit
import Foundation

class AddCalendarPopUpVC : BaseVC {
    
    @IBOutlet weak var addSlot: UIButton!
    @IBOutlet weak var blockDay: UIButton!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var selectSlotBtn: UIButton!
    @IBOutlet weak var blockDateBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
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
    
    @IBAction func btnBlock(_ sender: Any) {
    }
    
    
    @IBAction func btnSave(_ sender: Any) {
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
