//
//  AddPaymentVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 23/08/21.
//

import UIKit
import Foundation
import MonthYearPicker

class AddPaymentVC : BaseVC, UITextFieldDelegate {
    
    @IBOutlet weak var cardTypeTxtField: FGCardTypeTextField!
    @IBOutlet weak var cardNumberTxtField: FGCardNumberTextField!
    @IBOutlet weak var nameOnCardTxtField: FGAccountHolderNameTextField!
    @IBOutlet weak var expirationTxtField: FGPickMonthYear!
    @IBOutlet weak var cvvTxtField: FGCardNumberTextField!
    @IBOutlet weak var btnSubmit: FGActiveButton!
    
    var picker = MonthYearPickerView()
    
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
    
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: cardTypeTxtField.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.selectCardType) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: cardNumberTxtField.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterCardNumber) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: nameOnCardTxtField.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.nameOnCard) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: cvvTxtField.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterCVV) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: expirationTxtField.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterExpirationDate) {
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: expirationTxtField.text!, for: RegularExpressions.expiryDate) == false {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterValidExpirationDate) {
            }
            return false
        }
        
        return true
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
    }
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

