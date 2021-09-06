//
//  AddGuestVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 03/09/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class AddGuestVC : BaseVC {
    
    @IBOutlet weak var guestLbl: UILabel!
    @IBOutlet weak var addImg: UIImageView!
    @IBOutlet weak var subtractImg: UIImageView!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var centerFrame : CGRect!
    
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
    
    func presentPopUp()  {
        
        dataView.frame = CGRect(x: centerFrame.origin.x, y: view.frame.size.height, width: centerFrame.width, height: centerFrame.height)
        dataView.isHidden = false
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.90, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.dataView.frame = self.centerFrame
        }, completion: nil)
    }
    
    func dismissPopUp(_ dismissed:@escaping ()->())  {
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.90, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.dataView.frame = CGRect(x: self.centerFrame.origin.x, y: self.view.frame.size.height, width: self.centerFrame.width, height: self.centerFrame.height)
            
        },completion:{ (completion) in
            self.dismiss(animated: false, completion: {
            })
        })
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnSubtract(_ sender: Any) {
    }
    
    @IBAction func btnAdd(_ sender: Any) {
    }
    
    @IBAction func btnClear(_ sender: Any) {
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
