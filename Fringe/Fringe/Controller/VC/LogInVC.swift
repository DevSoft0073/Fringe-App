//
//  LogInVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 11/08/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class LogInVC : BaseVC,UITextFieldDelegate,UITextViewDelegate {
    
    
    @IBOutlet weak var txtEmail: FGEmailTextField!
    @IBOutlet weak var txtPassword: FGPasswordTextField!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    
    
    
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //MARK: Customs
    
    func setup() {
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        //        btnRememberMe.delegate = self
        
      
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtEmail.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterEmail) {
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: txtEmail.text!, for: RegularExpressions.email) == false {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterValidEmail) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtPassword.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterPassword) {
            }
            return false
        }
        
        return true
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
    
    
    //------------------------------------------------------
    
    //MARK: Actions
  
    @IBAction func btnForgot(_ sender: Any) {
        let controller = NavigationManager.shared.forgotPasswordVC
        push(controller: controller)
        
    }
    
    @IBAction func btnLogInTapped(_ sender: Any) {
//        if validate() == false {
//            return
//        }
        NavigationManager.shared.setupLanding()
        
    }
    
    @IBAction func btnAppleTap(_ sender: Any) {
    }
    
    @IBAction func btnGoogleTap(_ sender: Any) {
    
    }
    
    @IBAction func btnFaceBookTap(_ sender: Any) {
    }
    
    @IBAction func btnSignUpTap(_ sender: Any) {
        let controller = NavigationManager.shared.signUpVC
        push(controller: controller)
    }
}
