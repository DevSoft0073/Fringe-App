//
//  AddPaymentVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 23/08/21.
//

import UIKit
import Stripe
import Foundation
import MonthYearPicker

class AddPaymentVC : BaseVC, UITextFieldDelegate {
    
    @IBOutlet weak var cardTypeTxtField: FGCardTypeTextField!
    @IBOutlet weak var cardNumberTxtField: FGCardNumberTextField!
    @IBOutlet weak var nameOnCardTxtField: FGAccountHolderNameTextField!
    @IBOutlet weak var expirationTxtField: FGPickMonthYear!
    @IBOutlet weak var cvvTxtField: FGCardNumberTextField!
    @IBOutlet weak var btnSubmit: FGActiveButton!
    
    var tokenID = String()
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
    
    //MARK: Custome
    
    func performValidateCardDetails() {
        
        let stripeCard = STPCardParams()
        if self.expirationTxtField.text?.isEmpty == false {
            let expirationDate = self.expirationTxtField.text?.components(separatedBy: "/")
            if expirationDate?.count != 2 {
                print("add year")
            }else{
                if let expYear = UInt(expirationDate![1]),let selectedMonth = Months.allCases.filter({$0.rawValue == expirationDate![0]}).first {
                    let expMonth = selectedMonth.monthIntVal
                    stripeCard.number = self.cardNumberTxtField.text?.replacingOccurrences(of: "-", with: "")
                    stripeCard.cvc = self.cvvTxtField.text
                    stripeCard.expMonth = UInt(expMonth)
                    stripeCard.expYear = expYear
                    stripeCard.name = nameOnCardTxtField.text!
                }
            }
        }
        //            LoadingManager.shared.hideLoading()
        if STPCardValidator.validationState(forCard: stripeCard) == .invalid{
            self.btnSubmit.isUserInteractionEnabled = true
            DisplayAlertManager.shared.displayAlert(animated: true, message: LocalizableConstants.Error.cardDetailsNotValid.localized())
            return
        }
        //        DispatchQueue.main.async {
        //
        //            LoadingManager.shared.showLoading()
        //
        //        }
        STPAPIClient.shared.createToken(withCard: stripeCard) { (token, error) in
            
            if error != nil{
                print("stripe expiration error",error!.localizedDescription)
                var message = error!.localizedDescription
                if message == "The card\'s expiration month is invalid"{
                    message = "The card expiration month is invalid"
                }else if message == "The card\'s number is invalid"{
                    message = "The card number is invalid"
                } else{
                    message = error?.localizedDescription ?? String()
                }
                self.btnSubmit.isUserInteractionEnabled = true
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    DisplayAlertManager.shared.displayAlert(animated: true, message: message)
                }
                
            }else{
                if let tokenString = token?.tokenId{
                    self.tokenID = tokenString
                    print(tokenString)
                    
                    LoadingManager.shared.showLoading()
                    self.btnSubmit.isUserInteractionEnabled = true
                    delayInLoading {
                        
                        self.performAddCardDetails { (flag: Bool) in
                            if flag {
                                DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.SuccessMessage.addedCard.localized()) {
                                    self.pop()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func performAddCardDetails(completion:((_ flag: Bool) -> Void)?) {

        let parameter: [String: Any] = [
            Request.Parameter.userID: PreferenceManager.shared.userId ?? String(),
            Request.Parameter.stripeToken: tokenID,
//            Request.Parameter.card_type: cardTypeTxtFld.text ?? String(),
//            Request.Parameter.name: nameOnCardTxtFld.text ?? String(),
        ]
        

        RequestManager.shared.requestPOST(requestMethod: Request.Method.addCardDetails, parameter: parameter, showLoader: false, decodingType: ResponseModal<[AddCardDetailsModal]>.self, successBlock: { (response: ResponseModal<[AddCardDetailsModal]>) in

            LoadingManager.shared.hideLoading()

            if response.code == Status.Code.success {
                delay {
                    completion?(true)
                }
                
            } else {
                
                if response.code == Status.Code.alredayUsedToken{
                    delay {
                        DisplayAlertManager.shared.displayAlert(animated: true, message: response.message ?? String(), handlerOK: nil)
                    }
                }
            }

        }, failureBlock: { (error: ErrorModal) in

            LoadingManager.shared.hideLoading()

            delay {
                DisplayAlertManager.shared.displayAlert(animated: true, message: error.errorDescription, handlerOK: nil)
            }
        })
    }
    
    
    //------------------------------------------------------
    
    //MARK: TextField Delegate Method(s)
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxNumberOfCharacters = 16
        let textString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let invalidCharacters = NSCharacterSet.decimalDigits.inverted
        if textField == self.cardNumberTxtField  && string.count > 0{
            guard string.compactMap({ Int(String($0)) }).count ==
                string.count else { return false }
            let text = textField.text ?? ""
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormatted()
            }
            else {
                let newText = String((text + string).filter({ $0 != "-" }).prefix(maxNumberOfCharacters))
                textField.text = newText.chunkFormatted()
            }
            return false
        }
        if textField == self.cvvTxtField  && string.count > 0{
            return (string.rangeOfCharacter(from: invalidCharacters) == nil) && textString.count <= 4
        }
        if textField == self.expirationTxtField {
            if expirationTxtField.text!.count == 2 && string.count>0{
                expirationTxtField.text = "\(expirationTxtField.text!)/"
            }
            if textField == self.expirationTxtField  && string.count > 0{
                return (string.rangeOfCharacter(from: invalidCharacters) == nil) && textString.count <= 5
            }
        }
        return true
    }

    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        if validate() == false {
            return
            
        }
//        btnSubmit.isUserInteractionEnabled = false
        self.view.endEditing(true)
        
        self.performValidateCardDetails()
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardNumberTxtField.delegate = self
        cardTypeTxtField.delegate = self
        cvvTxtField.delegate = self
        nameOnCardTxtField.delegate = self
        expirationTxtField.delegate = self
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}

