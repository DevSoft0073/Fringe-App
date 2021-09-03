//
//  ForgotPasswordVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 11/08/21.
//

import UIKit
import Alamofire
import Foundation
import IQKeyboardManagerSwift

class ForgotPasswordVC : BaseVC, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var txtEmail: FGEmailTextField!
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup() {

        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
        txtEmail.delegate = self
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtEmail.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterEmail) {
            }
            return false
        }
        return true
    }
    
    
    func performResetPassword() {
                        
        let headers:HTTPHeaders = [
           "content-type": "application/json",
           "Token": currentUser?.authorizationToken ?? String(),
          ]
        
        let parameter: [String: Any] = [
            Request.Parameter.email: txtEmail.text ?? String(),
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.forgotPassword, parameter: parameter, headers: headers, showLoader: false, decodingType: BaseResponseModal.self, successBlock: { (response: BaseResponseModal) in
            
            LoadingManager.shared.hideLoading()
            
            if response.code == Status.Code.success {
               
                delay {
                    
                    DisplayAlertManager.shared.displayAlert(animated: true, message: response.message ?? String(), handlerOK: {
                        
                        self.pop()
                    })
                }
                
            } else {
                
                delay {

                    if response.code == Status.Code.notRegistered {

                        DisplayAlertManager.shared.displayAlert(animated: true, message: response.message ?? String(), handlerOK: nil)

//                        DisplayAlertManager.shared.displayAlertWithNoYes(target: self, animated: true, message: LocalizableConstants.SuccessMessage.mailNotVerifiedYet, handlerNo: {
//
//                        }, handlerYes: {
//
//                            LoadingManager.shared.showLoading()
//
//                            delayInLoading {
//                                self.performResentEmailVerification()
//                            }
//                        })

                    } else {

//                       self.handleError(code: response.code)
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
    
    //MARK: Action
    
    @IBAction func btnSubmit(_ sender: Any) {
        
        if validate() == false {
            return
        }
        
        LoadingManager.shared.showLoading()

        performResetPassword()
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
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
    
}
