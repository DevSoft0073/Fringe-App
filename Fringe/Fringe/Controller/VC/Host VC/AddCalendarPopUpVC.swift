//
//  AddCalendarPopUpVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 31/08/21.
//
import UIKit
import Alamofire
import Foundation
import IQKeyboardManagerSwift

class AddCalendarPopUpVC : BaseVC {
    
    @IBOutlet weak var txtCalendar: FGSelectDateTextFieldForBooking!
    @IBOutlet weak var addSlot: UIButton!
    @IBOutlet weak var blockDay: UIButton!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var selectSlotBtn: UIButton!
    @IBOutlet weak var blockDateBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    var parameter: [String: Any] = [:]
    var selectedDate = String()
    var updateTblViewData:(()->Void)?
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var centerFrame : CGRect!
    var selected: Bool = Bool()
    
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
    
    func validateForDay() -> Bool {
        if ValidationManager.shared.isEmpty(text: txtCalendar.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.selecteDate) {
            }
            return false
        }
        return true
    }
    
    //------------------------------------------------------
    
    //MARK:  Dismiss Popup
    
    @objc func handleTap(_ sender:UITapGestureRecognizer){
        self.dismiss(animated: true) {
        }
    }
    
    private func performAddStudioBlokDate(completion:((_ flag: Bool) -> Void)?) {
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.abbBlockDate, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<AddBlockDate>.self, successBlock: { (response: ResponseModal<AddBlockDate>) in
            
            LoadingManager.shared.hideLoading()
            
            if response.code == Status.Code.success{
                
                delay {
                    
                    DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: response.message ?? "") {
                        self.updateTblViewData?()
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                }
                
            } else if response.code == 1 {
                
                delay {
                    
                    DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: response.message ?? "") {
                    }
                }
                
            } else if response.code == 1 {
                
                delay {
                    
                    DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: response.message ?? "") {
                    }
                }
                
            } else if response.code == 1 {
                
                delay {
                    
                    DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: response.message ?? "") {
                    }
                }
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
            delay {
            }
        })
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBlock(_ sender: Any) {
        if selected == true {
            selected = false
            parameter =  [
                Request.Parameter.golfID: currentUserHost?.golfID ?? String(),
                Request.Parameter.isBlock: "0",
                Request.Parameter.dates: txtCalendar.text ?? String(),
            ]
            blockDay.setImage(UIImage(named: FGImageName.iconRadioUnselect), for: .normal)
            addSlot.setImage(UIImage(named: FGImageName.iconRadio), for: .normal)
        }else{
            selected = true
            parameter =  [
                Request.Parameter.golfID: currentUserHost?.golfID ?? String(),
                Request.Parameter.isBlock: "1",
                Request.Parameter.dates: txtCalendar.text ?? String(),
            ]
            blockDay.setImage(UIImage(named: FGImageName.iconRadio), for: .normal)
            addSlot.setImage(UIImage(named: FGImageName.iconRadioUnselect), for: .normal)
        }
        
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        if validateForDay() == false {
            return
        }
        self.view.endEditing(true)
       
        LoadingManager.shared.showLoading()
        
        self.performAddStudioBlokDate { (flag : Bool) in
            
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtCalendar.text = selectedDate
//        txtCalendar.text = selectedDate.convertDatetring_TopreferredFormat(currentFormat: "dd-MM-yyyy", toFormat: "EEEE, MMM d, yyyy")
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(mytapGestureRecognizer)
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
