//
//  ChangePasswordVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 19/08/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class ChangePasswordVC : BaseVC , UITextViewDelegate , UITextFieldDelegate {
    
    @IBOutlet weak var imgConfirmPassword: UIImageView!
    @IBOutlet weak var imgNewPassword: UIImageView!
    @IBOutlet weak var txtOldPassword: FGPasswordTextField!
    @IBOutlet weak var txtNewPassword: FGPasswordTextField!
    @IBOutlet weak var txtConfirmPassword: FGPasswordTextField!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var iconClick = true
    var iconClick2 = true
    var textTitle: String?
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
        
        title = textTitle
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
        
        txtOldPassword.delegate = self
        txtNewPassword.delegate = self
        txtConfirmPassword.delegate = self
    }
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtOldPassword.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.oldPassword) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtNewPassword.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterNewPassword) {
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: txtNewPassword.text!, for: RegularExpressions.password8AS) == false {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterValidNewPassword) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtConfirmPassword.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterRetypePassword) {
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: txtConfirmPassword.text!, for: RegularExpressions.password8AS) == false {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterValidRetypePassword) {
            }
            return false
        }
        
        if (txtOldPassword.text == txtNewPassword.text) {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.oldNewPasswordNotSame) {
            }
            return false
        }
        
        if (txtNewPassword.text != txtConfirmPassword.text) {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.NewRetypePasswordNotMatch) {
            }
            return false
        }
        
        return true
    }
    
    private func performUpdatePassword(completion:((_ flag: Bool) -> Void)?) {
        
        let parameter: [String: Any] = [
            Request.Parameter.userID: currentUser?.userID ?? String(),
            Request.Parameter.oldPassword: txtOldPassword.text ?? String(),
            Request.Parameter.newPassword: txtNewPassword.text ?? String()
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.changePassword, parameter: parameter, headers: [:], showLoader: true, decodingType: BaseResponseModal.self, successBlock: { (response: BaseResponseModal) in
            
            LoadingManager.shared.hideLoading()
            
            if response.code == Status.Code.success {
                
                LoadingManager.shared.hideLoading()
                
                delay {
                    
                    DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.SuccessMessage.passwordChanged) {
                        
                        completion?(true)
                        
                        self.pop()
                    }
                }
                
            } else {
                
                LoadingManager.shared.hideLoading()
                
                completion?(false)
                
                delay {
                    DisplayAlertManager.shared.displayAlert(animated: true, message: response.message ?? String())
                    //                    self.handleError(code: response.code)
                }
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
            completion?(false)
            
            delay {
                
                DisplayAlertManager.shared.displayAlert(target: self, animated: false, message: LocalizableConstants.Error.anotherLogin) {
                    PreferenceManager.shared.userId = nil
                    PreferenceManager.shared.currentUser = nil
                    PreferenceManager.shared.authToken = nil
                    NavigationManager.shared.setupSingIn()
                }
            }
        })
    }
    
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    
    @IBAction func btnSave(_ sender: Any) {
        
        if validate() == false {
            return
        }
        
        self.view.endEditing(true)
        
//        LoadingManager.shared.showLoading()
        
        self.performUpdatePassword { (flag : Bool) in
            
        }
    }
    
    @IBAction func btnNewPassword(_ sender: Any) {
        if(iconClick == true) {
            txtNewPassword.isSecureTextEntry = false
            imgNewPassword.image = UIImage(named: FGImageName.iconOpenEye)
        } else {
            txtNewPassword.isSecureTextEntry = true
            imgNewPassword.image = UIImage(named: FGImageName.iconEye)
        }
        iconClick = !iconClick
    }
    
    @IBAction func btnConfirmPassword(_ sender: Any) {
        if(iconClick2 == true) {
            txtConfirmPassword.isSecureTextEntry = false
            imgConfirmPassword.image = UIImage(named: FGImageName.iconOpenEye)
        } else {
            txtConfirmPassword.isSecureTextEntry = true
            imgConfirmPassword.image = UIImage(named: FGImageName.iconEye)
        }
        iconClick2 = !iconClick2
    }
    
    //------------------------------------------------------
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if IQKeyboardManager.shared.canGoNext {
            IQKeyboardManager.shared.goNext()
        } else {
            self.view.endEditing(true)
        }
        return true
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationManager.shared.isEnabledBottomMenu = false
        NavigationManager.shared.isEnabledBottomMenuForHost = false
    }
    
    //------------------------------------------------------
}
