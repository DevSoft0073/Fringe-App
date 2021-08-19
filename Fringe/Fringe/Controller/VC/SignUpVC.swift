//
//  SignUpVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 11/08/21.
//
import UIKit
import Foundation
import IQKeyboardManagerSwift

class SignUpVC : BaseVC , UITextFieldDelegate, UITextViewDelegate {
    
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
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var unchecked = Bool()
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
        
        
        if ValidationManager.shared.isEmpty(text: txtPassword.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterPassword) {
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: txtConfirmPassword.text!, for: RegularExpressions.password8AS) == false {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterRetypePassword) {
            }
            return false
        }
        
        
        //        if unchecked == false{
        //            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.agreeTermsAndConditions, handlerOK: <#(() -> Void)?#>)
        //            return false
        //        }
        return true
    }
   
   
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnProfileImg(_ sender: Any) {
    }
    
    
    @IBAction func btnCheckUncheck(_ sender: Any) {
        if (unchecked == false)
        {
            checkUncheckBtn.setBackgroundImage(UIImage(named: FGImageName.iconCheck), for: UIControl.State.normal)
            unchecked = true
        }
        else
        {
            checkUncheckBtn.setBackgroundImage(UIImage(named: FGImageName.iconUncheck), for: UIControl.State.normal)
            unchecked = false
        }
    }
    
    @IBAction func btnTermCondition(_ sender: Any) {
    }
    
    @IBAction func btnSignUp(_ sender: UIButton) {
        if validate() == false {
            return
        }
        self.pop()
    }
    
    @IBAction func btnAppleTap(_ sender: Any) {
    }
    
    @IBAction func btnGoogleTap(_ sender: Any) {
    }
    
    @IBAction func btnFacebookTap(_ sender: Any) {
    }
    
    
    @IBAction func btnLoginTap(_ sender: Any) {
        self.pop()
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
    }
}

