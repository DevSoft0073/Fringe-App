//
//  SignUpVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 11/08/21.
//
import UIKit
import Foundation
import IQKeyboardManagerSwift

class SignUpVC : BaseVC , UITextViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var checkUncheckBtn: UIButton!
    @IBOutlet weak var txtUserName: FGUsernameTextField!
    @IBOutlet weak var txtBirthDate: FGBirthDateTextField!
    @IBOutlet weak var txtGender: FGGenderTextField!
    @IBOutlet weak var txtMobileNumber: FGMobileNumberTextField!
    @IBOutlet weak var txtHomeTown: FGUsernameTextField!
    @IBOutlet weak var txtProffession: FGUsernameTextField!
    @IBOutlet weak var txtMemberCourse: FGUsernameTextField!
    @IBOutlet weak var txtGolfHandicap: FGUsernameTextField!
    @IBOutlet weak var txtPassword: FGPasswordTextField!
    @IBOutlet weak var txtConfirmPassword: FGPasswordTextField!
    var returnKeyHandler: IQKeyboardReturnKeyHandler
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
//        imgProfile.image = getPlaceholderImage()
//        imagePickerVC = ImagePicker(presentationController: self, delegate: self)
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
        
        txtUserName.delegate = self
        txtHomeTown.delegate = self
        txtBirthDate.delegate = self
        txtGender.delegate = self
        txtProffession.delegate = self
        txtMobileNumber.delegate = self
        txtMemberCourse.delegate = self
        txtGolfHandicap.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtUserName.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterUserName) {
            }
            return false
        }
        
    
        if ValidationManager.shared.isEmpty(text: txtBirthDate.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.selectBirthDate) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtGender.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.selectGender) {
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtMobileNumber.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterValidMobileNumber) {
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtHomeTown.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterHomeTown) {
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtProffession.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterProffession) {
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtMemberCourse.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterMemberCousre) {
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtGolfHandicap.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterGolfHandicap) {
            }
            return false
        }
        
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
        
        if ValidationManager.shared.isEmpty(text: txtMobileNumber.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterMobileNumber) {
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: txtMobileNumber.text!, for: RegularExpressions.phone) == false {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterValidMobileNumber) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtPassword.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterPassword) {
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: txtPassword.text!, for: RegularExpressions.password8AS) == false {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterValidPassword) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtConfirmPassword.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterRetypePassword) {
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: txtPassword.text!, for: RegularExpressions.password8AS) == false {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterValidRetypePassword) {
            }
            return false
        }
        
        if ValidationManager.shared.isValidConfirm(password: txtPassword.text!, confirmPassword: txtConfirmPassword.text!) == false {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.NewRetypePasswordNotMatch) {
            }
            return false
        }
        
        if unchecked == false{
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.agreeTermsAndConditions)
            return false
        }
        return true
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
