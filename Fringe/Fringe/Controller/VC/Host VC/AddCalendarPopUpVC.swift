//
//  AddCalendarPopUpVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 31/08/21.
//
import UIKit
import Foundation
import IQKeyboardManagerSwift

protocol SendSelectedDate {
    func sendSelectedDate (date : Date)
}

class AddCalendarPopUpVC : BaseVC {
    
    @IBOutlet weak var txtCalendar: FGSelectDateTextFieldForBooking!
    @IBOutlet weak var addSlot: UIButton!
    @IBOutlet weak var blockDay: UIButton!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var selectSlotBtn: UIButton!
    @IBOutlet weak var blockDateBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var centerFrame : CGRect!
    var selected: Bool = Bool()
    var selectedDateDelegate : SendSelectedDate?
    
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
    
    //MARK:  Dismiss Popup
    
    @objc func handleTap(_ sender:UITapGestureRecognizer){
        self.dismiss(animated: true) {
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBlock(_ sender: Any) {
        if selected == true {
            selected = false
            blockDay.setImage(UIImage(named: FGImageName.iconRadioUnselect), for: .normal)
            addSlot.setImage(UIImage(named: FGImageName.iconRadio), for: .normal)
        }else{
            selected = true
            blockDay.setImage(UIImage(named: FGImageName.iconRadio), for: .normal)
            addSlot.setImage(UIImage(named: FGImageName.iconRadioUnselect), for: .normal)
        }
        
    }
    
    @IBAction func btnSave(_ sender: Any) {
        self.dismiss(animated: true)
    }
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(mytapGestureRecognizer)
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
